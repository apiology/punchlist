# frozen_string_literal: true

module Punchlist
  # Configuration for punchlist gem
  class Config
    attr_reader :regexp, :glob, :exclude

    def self.default_punchlist_line_regexp_string
      'XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT'
    end

    def source_files
      @source_file_globber.source_files_glob = glob if glob
      @source_file_globber.source_files_exclude_glob = exclude if exclude
      @source_file_globber.source_files_arr
    end

    def initialize(regexp: nil, glob: nil, exclude: nil,
                   source_file_globber:)
      @regexp = Regexp.new(regexp ||
                           Config.default_punchlist_line_regexp_string)
      @glob = glob
      @exclude = exclude
      @source_file_globber = source_file_globber
    end
  end
end
