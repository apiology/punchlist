# frozen_string_literal: true

require_relative 'offense'

module Punchlist
  # Inspects files for punchlist items
  class Inspector
    attr_reader :punchlist_line_regexp, :filename
    def initialize(punchlist_line_regexp, filename, file_opener:)
      @file_opener = file_opener
      @punchlist_line_regexp = punchlist_line_regexp
      @filename = filename
      @lines = []
      @line_num = 0
    end

    def inspect_line(line)
      @line_num += 1
      return unless line =~ punchlist_line_regexp

      @lines << Offense.new(filename, @line_num, line.chomp)
    end

    def run
      @file_opener.open(filename, 'r') do |file|
        file.each_line { |line| inspect_line(line) }
      end
      @lines
    end
  end
end
