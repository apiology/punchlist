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

    def self.default_punchlist_line_regexp_string
      'XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT'
    end

    def self.default_punchlist_line_regexp
      Regexp.new(default_punchlist_line_regexp_string)
    end

    def parse_regexp(opts, options)
      opts.on('-r', '--regexp r',
              'Regexp to trigger upon - default is ' \
              "#{self.class.default_punchlist_line_regexp_string}") do |v|
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

    def generate_config
      options = nil
      ::OptionParser.new do |opts|
        options = setup_options(opts)
      end.parse!(@args)
      Config.new(**options)
    end
  end
end
