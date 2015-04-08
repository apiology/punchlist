# XXX: need to include BUG in list
# XXX: need to include BUG in my rubocop config
# BUG need to fix the fact that we create blank lines on files with no issues
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

      analyze_files

      0
    end

    def source_files_glob
      @source_files_glob ||=
        '{app,lib,test,spec,feature}/**/*.{rb,swift,scala,js,cpp,c,java,py}'
    end

    def analyze_files
      all_output = []
      source_files.each do |filename|
        all_output.concat(look_for_punchlist_items(filename))
      end
      @outputter.print render(all_output)
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
      lines = output.map do |filename, line_num, line|
        "#{filename}:#{line_num}: #{line}"
      end
      lines.join
    end
  end
end
