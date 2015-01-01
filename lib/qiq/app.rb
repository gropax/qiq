require 'rubygems'
require 'commander'

require_relative "../qiq"

module Qiq
  class App
    include Commander::Methods

    def initialize(argv = ARGV)
      ::Commander::Runner.instance.instance_variable_set(:@args, argv)
    end

    def run
      program :name, 'Qiq'
      program :version, '0.0.1'
      program :description, 'Manage notes with buffer and tag support'

      command :note do |c|
        c.syntax = 'qiq note [options]'
        c.summary = 'Create note'

        c.option 'c', '--content', 'Note content'

        c.action Qiq::Command::Note, :create
      end

      run!
    end
  end
end

