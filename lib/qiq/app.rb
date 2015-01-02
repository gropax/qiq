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

        # Print Note
        #
        c.option '-p', '--print NOTE_ID', 'Print a note' do |note_id|
          @action = :print
          @note_id = note_id
        end

        # Delete Note
        #
        c.option '-d', '--delete NOTE_ID', 'Delete a note' do |note_id|
          @action = :delete
          @note_id = note_id
        end

        # Update Note
        #
        c.option '-u', '--update NOTE_ID', 'Modify a note' do |note_id|
          @action = :update
          @note_id = note_id
        end

        # Note content options
        #
        c.option '-e', '--editor [EDITOR]', 'Create note in text editor' do |editor|
          e = editor.is_a?(String) ? editor : nil
          @content = ask_editor('', e)
        end
        #
        c.option '-c', '--content STRING', 'Note content' do |content|
          @content = content
        end
        #
        c.option '-f', '--file FILE', 'Content from file' do |file|
          @content = File.open(file).read
        end

        c.action do |args, options|
          case @action
          when :print
            Qiq::Command::Note.new.print(@note_id, options)
          when :delete
            Qiq::Command::Note.new.delete(@note_id)
          when :update
            @content ||= $stdin.read
            Qiq::Command::Note.new.update(@note_id, @content, options)
          else #create
            @content ||= $stdin.read
            Qiq::Command::Note.new.create(@content, options)
          end
        end
      end

      command :"note list" do |c|
        c.syntax = 'qiq note list [options]'
        c.summary = 'List notes'

        c.action do |args, options|
          STDOUT.puts "List notes"
          Qiq::Command::Note.new.list
        end
      end

      run!
    end
  end
end

