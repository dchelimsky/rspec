module Spec
  module Runner
    class TextOutputter
      def initialize(output)
        @output = output
      end
      
      def add_context(name, first, verbose)
        @output << "\n" if first unless verbose
        @output << "\n#{name}\n" if verbose
      end
      
      def spec_failed(name, counter, verbose)
        @output << "- #{name} (FAILED - #{counter})\n" if verbose
        @output << 'F' unless verbose
      end
      
      def spec_passed(name, verbose)
        @output << "- #{name}\n" if verbose
        @output << '.' unless verbose
      end
      
      def start_dump(verbose)
        @output << "\n" unless verbose
      end
      
      def dump_failure(counter, failure)
        @output << "\n"
        @output << counter.to_s << ")\n"
        @output << "#{failure.header}\n"
        @output << "#{failure.message}\n"
        @output << "#{failure.backtrace}\n"
      end
      
      def dump_summary(duration, context_count, spec_count, failure_count)
        @output << "\n"
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{context_count} context#{'s' unless context_count == 1}, "
        @output << "#{spec_count} specification#{'s' unless spec_count == 1}, "
        @output << "#{failure_count} failure#{'s' unless failure_count == 1}"
        @output << "\n"
      end
    end
  end
end