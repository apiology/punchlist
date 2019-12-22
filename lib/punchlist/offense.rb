module Punchlist
  # Represents a discovered punchlist item in code
  class Offense
    attr_reader :filename, :line_num, :line
    def initialize(filename, line_num, line)
      @filename = filename
      @line_num = line_num
      @line = line
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [@filename, @line_num, @line]
    end
  end
end
