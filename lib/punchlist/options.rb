require 'optparse'

module Punchlist
  # Parse command line options
  class Options
    attr_reader :default_punchlist_line_regexp

    def initialize(args)
      @args = args
    end

    def parse_glob(opts, options)
      opts.on('-g', '--glob g', 'Filename glob to identify source files') do |v|
        options[:glob] = v
      end
    end

    def parse_regexp(opts, options)
      opts.on('-r', '--regexp r',
              'Regexp to trigger on - ' \
              'default is XXX|TODO') do |v|
        options[:regexp] = v
      end
    end

    def setup_options(opts)
      options = {}
      opts.banner = 'Usage: punchlist [options]'
      parse_glob(opts, options)
      parse_regexp(opts, options)
      options
    end

    def parse_options
      options = nil
      OptionParser.new do |opts|
        options = setup_options(opts)
      end.parse!(@args)
      options
    end
  end
end
