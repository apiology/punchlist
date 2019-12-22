# frozen_string_literal: true

require_relative 'punchlist/options'
require_relative 'punchlist/inspector'

# XXX: need to include BUG in list
# XXX: need to include BUG in my rubocop config
# BUG need to fix the fact that we create blank lines on files with no issues
module Punchlist
  # Counts the number of 'todo' comments in your code.
  class Punchlist
    def initialize(args,
                   outputter: STDOUT,
                   file_opener: File,
                   options_parser: Options.new(args),
                   source_file_globber: SourceFinder::SourceFileGlobber.new)
      @args = args
      @outputter = outputter
      @file_opener = file_opener
      @options_parser = options_parser
      @source_file_globber = source_file_globber
    end

    def run
      @options = @options_parser.parse_options

      analyze_files

      0
    end

    def analyze_files
      all_output = []
      source_files.each do |filename|
        all_output.concat(look_for_punchlist_items(filename))
      end
      @outputter.print render(all_output)
    end

    def source_files
      if @options[:glob]
        @source_file_globber.source_files_glob = @options[:glob]
      end
      if @options[:exclude]
        @source_file_globber.source_files_exclude_glob = @options[:exclude]
      end
      @source_file_globber.source_files_arr
    end

    def punchlist_line_regexp
      return @regexp if @regexp

      regexp_string = @options[:regexp]
      if regexp_string
        @regexp = Regexp.new(regexp_string)
      else
        Options.default_punchlist_line_regexp
      end
    end

    def look_for_punchlist_items(filename)
      Inspector.new(punchlist_line_regexp, filename,
                    file_opener: @file_opener).run
    end

    def render(output)
      lines = output.map do |filename, line_num, line|
        "#{filename}:#{line_num}: #{line}"
      end
      lines.join
    end
  end
end
