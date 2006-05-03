module Spec
  module Runner
    class BaseTextFormatter
      def set_dry_run
        @dry_run = true
      end
      
      def dump_failure(counter, failure)
        @output << "\n"
        @output << counter.to_s << ")\n"
        @output << "#{failure.header}\n"
        @output << "#{failure.message}\n"
        @output << "#{failure.backtrace}\n"
      end
      
      def dump_summary(duration, context_count, spec_count, failure_count)
        return if @dry_run
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