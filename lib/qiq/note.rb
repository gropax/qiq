require 'active_resource'

module Qiq
  class Note < ActiveResource::Base
    self.site = Qiq::SERVER
  end
end
