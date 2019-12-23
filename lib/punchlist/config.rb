# frozen_string_literal: true

module Punchlist
  # Configuration for punchlist gem
  class Config
    attr_reader :regexp, :glob, :exclude

    def self.default_punchlist_line_regexp_string
      'XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT'
    end

    def initialize(regexp: nil, glob: nil, exclude: nil)
      @regexp = Regexp.new(regexp ||
                           Config.default_punchlist_line_regexp_string)
      @glob = glob
      @exclude = exclude
    end
  end
end
