module Punchlist
  # Configuration for punchlist gem
  class Config
    attr_reader :regexp, :glob, :exclude

    def initialize(regexp: nil, glob: nil, exclude: nil)
      @regexp = regexp
      @glob = glob
      @exclude = exclude
    end
  end
end
