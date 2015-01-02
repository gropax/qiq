module Qiq
  class Command
    class Note
      def initialize(stdout = $stdout, stderr = $stderr)
        @stdout = stdout
        @stderr = stderr
      end

      def create(content, options = nil)
        note = Qiq::Note.create({content: content})
        @stdout.puts "(Created note *#{note.id})"
      end

      def print(note_id, options = nil)
        check_found {
          note = Qiq::Note.find(note_id)
          @stdout.puts format_note(note)
        }
      end

      def update(note_id, content, options = nil)
        check_found {
          note = Qiq::Note.find(note_id)
          note.content = content
          note.save
          @stdout.puts "(Updated note *#{note.id})"
        }
      end

      def delete(note_id, options = nil)
        check_found {
          Qiq::Note.delete(note_id)
          @stdout.puts "(Deleted note *#{note_id})"
        }
      end

      def list(options = nil)
        notes = Qiq::Note.all
        @stdout.puts notes.map { |n| format_note(n) }.join("\n"*2)
      end

      private

        def format_note(note)
          "Note *#{note.id}:\n#{note.content}"
        end

        def check_found
          yield
        rescue ActiveResource::ResourceNotFound
          @stderr.puts "Note not found"
        end
    end
  end
end
