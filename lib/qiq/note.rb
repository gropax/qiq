require 'active_resource'

module Qiq
  class Note < ActiveResource::Base
    self.site = "http://www.gropax.ninja"
  end
end
