require "active_resource"

class Bougle < ActiveResource::Base
  self.site = "http://www.gropax.ninja"
end

module Qiq
  describe Note do
    describe "#create" do
      it "POST /notes.json" do
        stub_request(:post, "www.gropax.ninja/bougles.json").to_return(status: 200)

        Bougle.create({})
        #uri = URI("http://www.gropax.ninja")
        #Net::HTTP.post_form(uri, {})

        expect(WebMock).to have_requested(:post, "www.gropax.ninja/bougles")
      end
    end
  end
end
