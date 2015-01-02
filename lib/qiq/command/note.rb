module Qiq
  class Command
    class Note
      def initialize(stdout = $stdout)
        @stdout = stdout
      end

      def create(content, options = nil)
        note = Qiq::Note.create({content: content})
        @stdout.puts "(Created note *#{note.id})"
      end

      def print(note_id, options = nil)
        note = Qiq::Note.find(note_id)
        @stdout.puts "Note *#{note.id}:\n#{note.content}"
      end

      def update(note_id, content, options = nil)
        note = Qiq::Note.find(note_id)
        note.content = content
        note.save
        @stdout.puts "(Updated note *#{note.id})"
      end

      def delete(note_id, options = nil)
        Qiq::Note.delete(note_id)
        @stdout.puts "(Deleted note *#{note_id})"
      end
    end
  end
end
