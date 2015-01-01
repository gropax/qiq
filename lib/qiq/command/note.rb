module Qiq
  class Command
    class Note
      def create(content, options)
        note = Qiq::Note.create({content: content})
        $stdout.puts "(Created note *#{note.id})"
      end
    end
  end
end
