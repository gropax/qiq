require 'active_resource'

module Qiq
  class Note < ActiveResource::Base
    NoteError = Class.new(StandardError)

    self.site = Qiq::SERVER
    has_many :tags, class_name: 'qiq/tag'

    def add_tag(tag)
      persisted? || raise(NoteError, "Cannot add tag on non-persisted note")

      path = "/notes/#{id}/tags.json"
      req = Net::HTTP::Post.new(path, {'Content-Type' => 'application/json'})
      req.body = {tag_id: tag.id}.to_json
      res = Net::HTTP.new(Qiq::HOST, Qiq::PORT).start { |http| http.request(req) }

      reload
    end
  end
end
