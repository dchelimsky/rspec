module Spec
  module Runner
    # Parses a spec file and finds the nearest spec for a given line number.
    class SpecParser
      def spec_name_for(io, line_number)
        source  = io.read
        context, context_line = context_at_line(source, line_number)
        spec, spec_line = spec_at_line(source, line_number)
        if context && spec && (context_line < spec_line)
          "#{context} #{spec}"
        elsif context
          context
        else
          nil
        end
      end

    protected

      def context_at_line(source, line_number)
        find_above(source, line_number, /^\s*(context|describe)\s+['|"](.*)['|"]/)
      end

      def spec_at_line(source, line_number)
        find_above(source, line_number, /^\s*(specify|it)\s+['|"](.*)['|"]/)
      end

      # Returns the context/describe or specify/it name and the line number
      def find_above(source, line_number, pattern)
        lines_above_reversed(source, line_number).each_with_index do |line, n|
          return [$2, line_number-n] if line =~ pattern
        end
        nil
      end

      def lines_above_reversed(source, line_number)
        lines = source.split("\n")
      	lines[0...line_number].reverse
      end
    end
  end
end