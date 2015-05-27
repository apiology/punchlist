require 'optparse'

module Punchlist
  class Options
    attr_reader :default_punchlist_line_regexp

    def initialize(args)
      @args = args
    end

    def setup_options(opts)
      options = {}
      opts.banner = 'Usage: punchlist [options]'
      opts.on('-g', '--glob g', 'Filename glob to identify source files') do |v|
        options[:glob] = v
      end
      opts.on('-r', '--regexp r',
              'Regexp to trigger on - ' \
              'default is XXX|TODO') do |v|
        options[:regexp] = v
      end
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
