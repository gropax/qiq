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

        c.option '--ids', "Print only note's ids"

        c.action do |args, options|
          Qiq::Command::Note.new.list(options)
        end
      end

      command :"note tag" do |c|
        c.syntax = 'qiq note tag NOTE [options]'
        c.summary = "Manage note's tags"

        c.option '-a', '--add TAGS', "Add tags to a note" do |tags|
          @action = :add_tags
          @tags = tags.split(",")
        end

        c.option '-r', '--remove TAGS', "Remove tags from a note" do |tags|
          @action = :remove_tags
          @tags = tags.split(",")
        end

        c.option '-R', '--remove-all', "Remove all tags from a note" do
          @action = :remove_all_tags
        end

        c.action do |args, options|
          @note_id = args.shift

          case @action
          when :add_tags
            Qiq::Command::Note.new.add_tags(@note_id, @tags)
          when :remove_tags
            STDOUT.puts "Remove tags #{@tags.join(", ")} from note *#{@note_id}"
          when :remove_all_tags
            STDOUT.puts "Remove all tags form note *#{@note_id}"
          else #list_tags
            STDOUT.puts "List all tags of *#{@note_id}"
          end
        end
      end

      run!
    end
  end
end

