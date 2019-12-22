require_relative 'offense'

module Punchlist
  # Inspects files for punchlist items
  class Inspector
    attr_reader :punchlist_line_regexp, :filename
    def initialize(punchlist_line_regexp, filename, file_opener:)
      @file_opener = file_opener
      @punchlist_line_regexp = punchlist_line_regexp
      @filename = filename
    end

    def run
      lines = []
      line_num = 0
      @file_opener.open(filename, 'r') do |file|
        file.each_line do |line|
          line_num += 1
          if line =~ punchlist_line_regexp
            lines << Offense.new(filename, line_num, line.chomp)
          end
        end
      end
      lines
    end
  end
end
