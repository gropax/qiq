class Qiq::Command
  describe Note do
    let(:stdout) { StringIO.new }
    let(:stderr) { StringIO.new }
    let(:note_cmd) { Note.new(stdout, stderr) }

    let(:tag1) { {id:456, name: "bougle"} }
    let(:tag2) { {id:789, name: "trigle"} }

    let(:note) {
      {
        id: 123,
        content: "This is a cool note",
        tags: [],
      }
    }
    let(:updated_note) {
      note.dup.tap { |n| n[:content] = "This is an updated note" }
    }
    let(:note2) {
      {
        id: 456,
        content: "This is a second note",
      }
    }


    describe "#create" do
      before(:each) do
        stub_request(:post, "#{Qiq::SERVER}/notes.json").
          with(body: {content: "This is a cool note"}.to_json).
          to_return(body: note.to_json)
        note_cmd.create("This is a cool note")
      end

      it "requests POST /notes.json" do
        expect(WebMock).to have_requested(:post, "#{Qiq::SERVER}/notes.json")
      end

      it "writes the note to STDOUT" do
        expect(stdout.string).to match /Created note \*123/
      end
    end


    describe "#print" do
      before(:each) do
        stub_request(:get, "#{Qiq::SERVER}/notes/123.json").
          to_return(body: note.to_json)
        note_cmd.print(123)
      end

      it "requests GET /notes/:id.json" do
        expect(WebMock).to have_requested(:get, "#{Qiq::SERVER}/notes/123.json")
      end

      it "writes the note to STDOUT" do
        expect(stdout.string).to match(/123/)
        expect(stdout.string).to match(/This is a cool note/)
      end
    end


    describe "#update" do
      before(:each) do
        # GET /notes/123.json
        stub_request(:get, "#{Qiq::SERVER}/notes/123.json").
          to_return(body: note.to_json)
        # PUT /notes/123.json
        stub_request(:put, "#{Qiq::SERVER}/notes/123.json").
          with(body: hash_including({content: "This is an updated note"})).
          to_return(body: updated_note.to_json)

        note_cmd.update(123, "This is an updated note")
      end

      it "requests PUT /notes/:id.json" do
        expect(WebMock).to have_requested(:get, "#{Qiq::SERVER}/notes/123.json")
        expect(WebMock).to have_requested(:put, "#{Qiq::SERVER}/notes/123.json")
      end

      it "writes the note to STDOUT" do
        expect(stdout.string).to match /Updated note \*123/
      end
    end


    describe "#delete" do
      before(:each) do
        # DELETE /notes/123.json
        stub_request(:delete, "#{Qiq::SERVER}/notes/123.json")

        note_cmd.delete(123)
      end

      it "requests PUT /notes/:id.json" do
        expect(WebMock).to have_requested(:delete, "#{Qiq::SERVER}/notes/123.json")
      end

      it "writes the note to STDOUT" do
        expect(stdout.string).to match /Deleted note \*123/
      end
    end


    describe "#list" do
      before(:each) do
        # GET /notes/123.json
        stub_request(:get, "#{Qiq::SERVER}/notes.json").
          to_return(body: [note, note2].to_json)
      end

      context "without options" do
        before(:each) do
          opts = double("options", ids: false)
          note_cmd.list(opts)
        end

        it "requests GET /notes.json" do
          expect(WebMock).to have_requested(:get, "#{Qiq::SERVER}/notes.json")
        end

        it "writes all notes to STDOUT" do
          expect(stdout.string).to match /\*123/
          expect(stdout.string).to match /This is a cool note/
          expect(stdout.string).to match /\*456/
          expect(stdout.string).to match /This is a second note/
        end
      end

      context "with the '--ids' option" do
        it "writes all notes ids to STDOUT" do
          opts = double("options", ids: true)
          note_cmd.list(opts)
          expect(stdout.string).to match /123,456/
        end
      end
    end


    describe "#add_tags" do
      before(:each) do
        note[:tags] << tag1
        # GET notes/123.json
        stub_request(:get, "#{Qiq::SERVER}/notes/123.json").
          to_return(body: note.to_json)
        # GET tags.json
        stub_request(:get, "#{Qiq::SERVER}/tags.json").
          to_return(body: [tag1].to_json)
        # POST tags.json
        stub_request(:post, "#{Qiq::SERVER}/tags.json").
          to_return(body: tag2.to_json)
        # POST notes/123/tags.json
        stub_request(:post, "#{Qiq::SERVER}/notes/123/tags.json")

        note_cmd.add_tags(123, ["bougle", "trigle"])
      end

      it "creates the absent tag" do
        expect(WebMock).to have_requested(:post, "#{Qiq::SERVER}/tags.json").
          with(body: hash_including({name: "trigle"}))
      end

      it "adds the created tag to note's tags" do
        expect(WebMock).to have_requested(:post, "#{Qiq::SERVER}/notes/123/tags.json").
          with(body: hash_including({tag_id: 789}))
      end

      it "writes to STDOUT" do
        expect(stdout.string).to match /Added tags trigle to note \*123/
      end
    end


    describe "#check_found" do
      it "writes error to STDOUT if 404 Not Found" do
        note_cmd.send(:check_found) {
          raise ActiveResource::ResourceNotFound.new("")
        }
        expect(stderr.string).to match /Note not found/
      end
    end
  end
end
