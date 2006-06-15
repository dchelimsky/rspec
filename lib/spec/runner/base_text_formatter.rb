module Spec
  module Runner
    # Baseclass for text-based formatters. Can in fact be used for
    # non-text based ones too - just ignore the +output+ constructor
    # argument.
    class BaseTextFormatter
      def initialize(output, dry_run=false)
        @dry_run = dry_run
        @output = output
      end

      # This method is invoked before any specs are run, right after
      # they have all been collected. This can be useful for special
      # formatters that need to provide progress on feedback (graphical ones)
      #
      # This method will only be invoked once, and the next one to be invoked
      # is #add_context
      def start(spec_count)
      end

      # This method is invoked at the beginning of the execution of each context.
      # +name+ is the name of the context and +first+ is true if it is the
      # first context - otherwise it's false.
      #
      # The next method to be invoked after this is #spec_started
      def add_context(name, first)
      end

      # This method is invoked right before a spec is executed.
      # The next method to be invoked after this one is one of #spec_failed
      # or #spec_passed.
      def spec_started(name)
      end

      # This method is invoked when a spec fails, i.e. an exception occurred
      # inside it (such as a failed should or other exception). +name+ is the name
      # of the specification. +counter+ is the sequence number of the failure
      # (starting at 1) and +failure+ is the associated Failure object.
      def spec_failed(name, counter, failure)
      end

      # This method is invoked when a spec passes. +name+ is the name of the
      # specification.
      def spec_passed(name)
      end

      # This method is invoked after all of the specs have executed. The next method
      # to be invoked after this one is #dump_failure (once for each failed spec),
      def start_dump
      end

      # Dumps detailed information about a spec failure.
      # This method is invoked for each failed spec. +counter+ is the sequence number
      # of the associated spec. +failure+ is a Failure object, which contains detailed
      # information about the failure.
      def dump_failure(counter, failure)
        @output << "\n"
        @output << counter.to_s << ")\n"
        @output << "#{failure.header}\n"
        @output << "#{failure.message}\n"
        @output << "#{failure.backtrace}\n"
        @output.flush
      end
      
      # This method is invoked at the very end.
      def dump_summary(duration, spec_count, failure_count)
        return if @dry_run
        @output << "\n"
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{spec_count} specification#{'s' unless spec_count == 1}, "
        @output << "#{failure_count} failure#{'s' unless failure_count == 1}"
        @output << "\n"
        @output.flush
      end
    end
  end
end