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

        c.option '-e', '--editor [EDITOR]', 'Create note in text editor' do |editor|
          e = editor.is_a?(String) ? editor : nil
          @content = ask_editor('', e)
        end

        c.option '-c', '--content STRING', 'Note content' do |content|
          @content = content
        end

        c.option '-f', '--file FILE', 'Content from file' do |file|
          @content = File.open(file).read
        end

        c.action do |args, options|
          @content ||= $stdin.read
          Qiq::Command::Note.new.create(@content, options)
        end
      end

      run!
    end
  end
end

