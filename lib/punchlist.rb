# frozen_string_literal: true

require_relative 'punchlist/option_parser'
require_relative 'punchlist/inspector'
require_relative 'punchlist/renderer'

# XXX: need to include BUG in list
# XXX: need to include BUG in my rubocop config
module Punchlist
  # Counts the number of 'todo' comments in your code.
  class Punchlist
    def initialize(args,
                   outputter: STDOUT,
                   file_opener: File,
                   option_parser_class: OptionParser,
                   source_file_globber: SourceFinder::SourceFileGlobber.new)
      @config = option_parser_class.new(args).generate_config
      @outputter = outputter
      @file_opener = file_opener
      @source_file_globber = source_file_globber
    end

    def run
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
      @source_file_globber.source_files_glob = @config[:glob] if @config[:glob]
      if @config[:exclude]
        @source_file_globber.source_files_exclude_glob = @config[:exclude]
      end
      @source_file_globber.source_files_arr
    end

    def punchlist_line_regexp
      return @regexp if @regexp

      regexp_string = @config[:regexp]
      if regexp_string
        @regexp = Regexp.new(regexp_string)
      else
        OptionParser.default_punchlist_line_regexp
      end
    end

    def look_for_punchlist_items(filename)
      Inspector.new(punchlist_line_regexp, filename,
                    file_opener: @file_opener).run
    end

    def render(output)
      CliRenderer.new.render(output)
    end
  end
end
