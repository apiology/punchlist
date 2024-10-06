# frozen_string_literal: true

require_relative 'offense'

module Punchlist
  # Inspects files for punchlist items
  class Inspector
    # @param punchlist_line_regexp [Regexp] a regular expression that matches punchlist items
    # @param filename [String] the file to inspect
    # @param file_opener [Class<File>] an object that responds to `open` like `File`
    def initialize(punchlist_line_regexp, filename, file_opener: File)
      @file_opener = file_opener
      @punchlist_line_regexp = punchlist_line_regexp
      @filename = filename
      @lines = []
      @line_num = 0
    end

    # @return [Array<Offense>] punchlist items for the specified file
    def run
      @file_opener.open(filename, 'r') do |file|
        file.each_line { |line| inspect_line(line) }
      end
      @lines
    end

    private

    # @return [Regexp]
    attr_reader :punchlist_line_regexp

    # @return [String]
    attr_reader :filename

    # Inspects a line for punchlist items and stores it in this objects state
    #
    # @param line [String] the line to inspect
    # @return [void]
    def inspect_line(line)
      @line_num += 1
      return unless line =~ punchlist_line_regexp

      @lines << Offense.new(filename, @line_num, line.chomp)
    rescue ArgumentError => e
      if e.message != 'invalid byte sequence in UTF-8'
        # not a simple binary file we should ignore
        raise
      end
    end
  end
end
