require 'active_resource'

module Qiq
  class Tag < ActiveResource::Base
    self.site = Qiq::SERVER

    def self.find_or_create(name)
      tag = Tag.all.detect { |t| t.name == name }
      tag || Tag.create({name: name})
    end
  end
end
