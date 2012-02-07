module Emma
  class Control
    attr_accessor :debug, :em, :ec

    JAR = File.expand_path("../emma.jar", __FILE__)

    def initialize(opts = {})
      @em = opts[:metadata_file] || Tempfile.new("emma-metadata").path
      @ec = opts[:coverage_file] || Tempfile.new("emma-coverage").path
    end

    def get
      emma "ctl", "-c" "coverage.get,#{@ec},true,true"
    end

    def report(opts = {})
      format = opts[:format] || 'xml'

      emma "report", "-r", format, "-input", @em, "-input", @ec
    end

    def reset
      emma "ctl", "-c", "coverage.reset"
    end

    def instrument(paths, opts = {})
      mode = opts[:mode] || 'fullcopy'
      filter = opts[:filter] || '*'

      inputs = paths.map { |path| ['-instrpath', path] }.flatten

      emma 'instr',
           '-outmode', mode,
           '-outfile', @em,
           '-merge', 'yes',
           '-filter', filter,
           *inputs
    end

    def emma(*args)
      puts "emma #{args.join ' '}" if debug
      proc = ChildProcess.new("java", "-cp", JAR, 'emma', *args.map { |e| e.to_s })
      proc.io.inherit!

      proc.start
      proc.wait

      if proc.exit_code != 0
        raise Error, "emma failed with exit code"
      end
    end
  end
end