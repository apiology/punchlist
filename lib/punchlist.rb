module Punchlist
  # Counts the number of 'todo' comments in your code.
  class Punchlist
    def initialize(args,
                   outputter: STDOUT,
                   globber: Dir)
      @args = args
      @outputter = outputter
      @globber = globber
    end

    def run
      # if @args[0] == '-h'
      if @args[0]
        @outputter.puts "USAGE: punchlist\n"
      #   exit 0
      else
        source_files.each do |_filename|
          #   #   output = look_for_punchlist_items(filename)
          output = nil
          render(output)
        end
      end
    end
    #
    def source_files_glob
      '{app,lib,test,spec,feature}/**/*.{rb,swift,cpp,c,java,py}'
    end

    def source_files
      # puts "globbing #{source_files_glob}"
      out = @globber.glob(source_files_glob)
      # puts "found #{out}"
      out
    end
    #
    # def look_for_punchlist_items(filename)
    #   lines = []
    #   line_num = 0
    #   @file_opener.open(filename, 'r') do |file|
    #     file.each_line do |line|
    #       line_num += 1
    #       if file =~ punchlist_line_regexp
    #         lines << [line_num, line]
    #       end
    #     end
    #   end
    #   lines
    # end
    #
    def render(_output)
      @outputter.puts "foo.rb:3: puts 'foo' # XXX change to bar"
      #   output.map do |line_num, line|
      #     "#{line_num}: #{line}"
      #   end.join("\n")
    end
    #
  end
end
