# frozen_string_literal: true

module Punchlist
  # Render a text format of offenses
  class CliRenderer
    def render(output)
      lines = output.map do |offense|
        "#{offense.filename}:#{offense.line_num}: #{offense.line}"
      end
      out = lines.join("\n")
      if out.empty?
        out
      else
        out + "\n"
      end
    end
  end
end
