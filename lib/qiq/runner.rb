require_relative "app"

module Qiq
  class Runner
    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      exit_code = begin
        $stdin = @stdin
        $stdout = @stdout
        $stderr = @stderr

        Qiq::App.new(@argv).run

        return 0
      rescue StandardError => e
        b = e.backtrace
        @stderr.puts("#{b.shift}: #{e.message} (#{e.class})")
        @stderr.puts(b.map { |s| "\tfrom #{s}" }.join("\n"))
        1
      rescue SystemExit => e
        e.status
      ensure
        $stdin = STDIN
        $stdout = STDOUT
        $stderr = STDERR
      end

      @kernel.exit(exit_code)
    end

  end
end
