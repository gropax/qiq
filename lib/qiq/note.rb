require 'active_resource'

module Qiq
  class Note < ActiveResource::Base
    self.site = "http://www.gropax.ninja"

    def create(*args)
      puts "POST request, PID: #{Process.pid}"
      super
    end
  end
end
