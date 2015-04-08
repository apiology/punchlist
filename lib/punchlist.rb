module Punchlist
  # Counts the number of 'todo' comments in your code.
  class Punchlist
    def initialize(args,
                   outputter: STDOUT,
                   globber: Dir,
                   file_opener: File)
      @args = args
      @outputter = outputter
      @globber = globber
      @file_opener = file_opener
    end

    def run
      if @args[0] == '--glob'
        @source_files_glob = @args[1]
      elsif @args[0]
        @outputter.puts "USAGE: punchlist\n"
        return 0 # XXX: need to vary return based on good or bad arguments
      end

      source_files.each do |filename|
        output = look_for_punchlist_items(filename)
        @outputter.puts render(output)
      end

      0
    end

    def source_files_glob
      @source_files_glob ||=
        '{app,lib,test,spec,feature}/**/*.{rb,swift,scala,js,cpp,c,java,py}'
    end

    def source_files
      @globber.glob(source_files_glob)
    end

    def punchlist_line_regexp
      /XXX|TODO/
    end

    def look_for_punchlist_items(filename)
      lines = []
      line_num = 0
      @file_opener.open(filename, 'r') do |file|
        file.each_line do |line|
          line_num += 1
          lines << [filename, line_num, line] if line =~ punchlist_line_regexp
        end
      end
      lines
    end

    def render(output)
      output.map do |filename, line_num, line|
        "#{filename}:#{line_num}: #{line}"
      end.join("\n")
    end
  end
end
