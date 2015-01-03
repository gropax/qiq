module Qiq
  describe Note do
    before(:each) do
      # POST notes.json
      stub_request(:post, "#{Qiq::SERVER}/notes.json").
        with(body: hash_including({content: "Content"})).
        to_return(body: {id: 123, content: "Content", tags: []}.to_json)
    end

    let(:note) { Note.create({id: 123, content: "Content", tags: []}) }

    let(:tag) { Tag.new({id: 456, name: "bougle"}) }


    describe "#add_tag" do
      before(:each) do
        # POST notes/123/tags.json
        stub_request(:post, "#{Qiq::SERVER}/notes/123/tags.json").
          with(body: hash_including({tag_id: 456}))
        # GET notes/123.json
        stub_request(:get, "#{Qiq::SERVER}/notes/123.json").
          to_return(body: {id: 123, content: "Content", tags: [tag]}.to_json)

        note.add_tag(tag)
      end

      it "requests POST /notes/:id/tags.json" do
        expect(WebMock).to have_requested(:post, "#{Qiq::SERVER}/notes/123/tags.json").
          with(body: hash_including({tag_id: 456}))
      end

      it "update the note's tag attribute" do
        expect(note.tags).to eq [tag]
      end
    end
  end
end
