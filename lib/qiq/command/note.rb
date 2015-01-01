module Qiq
  class Command
    class Note
      def create(*args, options)
        content = options.content
        note = Qiq::Note.create({content: content})
        $stdout.puts "(Created note *#{note.id})"
      end
    end
  end
end
