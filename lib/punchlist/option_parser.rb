# frozen_string_literal: true

require 'optparse'
require 'source_finder/option_parser'
require_relative 'config'

module Punchlist
  # Parse command line options
  class OptionParser
    attr_reader :default_punchlist_line_regexp

    def initialize(args,
                   source_finder_option_parser: SourceFinder::OptionParser.new)
      @args = args
      @source_finder_option_parser = source_finder_option_parser
    end

    def parse_regexp(opts, options)
      opts.on('-r', '--regexp r',
              'Regexp to trigger upon - default is ' \
              "#{Config.default_punchlist_line_regexp_string}") do |v|
        options[:regexp] = v
      end
    end

    def setup_options(opts)
      options = {}
      opts.banner = 'Usage: punchlist [options]'
      @source_finder_option_parser.add_options(opts, options)
      parse_regexp(opts, options)
      options
    end

    def generate_config(source_file_globber)
      options = nil
      ::OptionParser.new do |opts|
        options = setup_options(opts)
      end.parse!(@args)
      Config.new(**options, source_file_globber: source_file_globber)
    end
  end
end
