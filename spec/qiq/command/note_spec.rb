class Qiq::Command
  describe Note do
    let(:stdout) { StringIO.new }
    let(:stderr) { StringIO.new }
    let(:note_cmd) { Note.new(stdout, stderr) }

    let(:note) {
      {
        id: 123,
        content: "This is a cool note",
        tags: [],
        buffers: [],
        created_at: Time.now.to_s,
        updated_at: Time.now.to_s,
      }
    }
    let(:updated_note) {
      note.dup.tap { |n| n[:content] = "This is an updated note" }
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

    describe "#update" do
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
