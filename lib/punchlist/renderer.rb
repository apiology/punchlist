module Punchlist
  # Render a text format of offenses
  class CliRenderer
    def render(output)
      lines = output.map do |offense|
        "#{offense.filename}:#{offense.line_num}: #{offense.line}"
      end
      lines.join
    end
  end
end
