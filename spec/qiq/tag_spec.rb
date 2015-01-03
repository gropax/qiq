module Qiq
  describe Tag do
    let(:tag_bougle) { {id: 456, name: "bougle"} }
    let(:tag_trigle) { {id: 789, name: "trigle"} }

    describe "::find_or_create" do
      before(:each) do
        # GET tags.json
        stub_request(:get, "#{Qiq::SERVER}/tags.json").
          to_return(body: [tag_bougle].to_json)
      end

      it "returns the tag" do
        tag = Tag.find_or_create("bougle")
        expect(tag).to be_kind_of(Tag)
        expect(tag.name).to eq("bougle")
      end

      context "when tag doesn't exist on server" do
        before(:each) do
          # POST tags.json
          stub_request(:post, "#{Qiq::SERVER}/tags.json").
            to_return(body: tag_trigle.to_json)
        end

        it "create tag on server" do
          Tag.find_or_create("trigle")
          expect(WebMock).to have_requested(:post, "#{Qiq::SERVER}/tags.json").
            with(body: hash_including({name: "trigle"}))
        end
      end
    end
  end
end
