module Punchlist
  class CliRenderer
    def render(output)
      lines = output.map do |filename, line_num, line|
        "#{filename}:#{line_num}: #{line}"
      end
      lines.join
    end
  end
end
