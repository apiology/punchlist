# frozen_string_literal: true

require_relative 'punchlist/version'
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
                   option_parser_class: OptionParser,
                   source_file_globber: SourceFinder::SourceFileGlobber.new)
      option_parser = option_parser_class.new(args)
      @config = option_parser.generate_config(source_file_globber)
      @outputter = outputter
    end

    def run
      analyze_files

      0
    end

    def analyze_files
      all_output = []
      @config.source_files.each do |filename|
        all_output.concat(look_for_punchlist_items(filename))
      end
      @outputter.print render(all_output)
    end

    def look_for_punchlist_items(filename)
      Inspector.new(@config.regexp, filename).run
    end

    def render(output)
      CliRenderer.new.render(output)
    end
  end
end
