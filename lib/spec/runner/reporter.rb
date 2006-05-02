module Spec
  module Runner
    class Reporter
      
      def initialize(output, verbose, backtrace_tweaker)
        @outputter = TextOutputter.new(output)
        @context_names = []
        @failures = []
        @spec_names = []
        @verbose = verbose
        @backtrace_tweaker = backtrace_tweaker
      end
  
      def add_context(name)
        @outputter.add_context(name, @context_names.empty?, @verbose)
        @context_names << name
      end
      
      def add_spec(name, error=nil, failure_location=nil)
        if error.nil?
          spec_passed(name)
        else
          @backtrace_tweaker.tweak_backtrace(error, failure_location)
          spec_failed(name, Failure.new(@context_names.last, name, error))
        end
      end
      
      def start(number_of_specs=0)
        @start_time = Time.new
      end
  
      def end
        @end_time = Time.new
      end
  
      def dump
        @outputter.start_dump(@verbose)
        dump_failures
        @outputter.dump_summary(duration, @context_names.length, @spec_names.length, @failures.length)
      end

      private
  
      def dump_failures
        return if @failures.empty?
        @failures.inject(1) do |index, failure|
          @outputter.dump_failure(index, failure)
          index + 1
        end
      end

      def duration
        return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
        return "0.0"
      end

      def spec_passed(name)
        @spec_names << name
        @outputter.spec_passed(name, @verbose)
      end

      def spec_failed(name, failure)
        @spec_names << name
        @failures << failure
        @outputter.spec_failed(name, @failures.length, @verbose)
      end

      class Failure
        def initialize(context_name, spec_name, error)
          @context_name = context_name
          @spec_name = spec_name
          @error = error
        end

        def header
          "#{class_name} in '#{@context_name} #{@spec_name}'"
        end

        def message
          @error.message
        end

        def backtrace
          @error.backtrace.join("\n") unless @error.backtrace.nil?
        end

        private

        def class_name
          @error.class.name.split('::').last
        end

      end
    end
  end
end