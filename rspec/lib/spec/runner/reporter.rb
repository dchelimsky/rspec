module Spec
  module Runner
    class Reporter
      
      def initialize(formatter, backtrace_tweaker, failure_io=nil)
        @formatter = formatter
        @backtrace_tweaker = backtrace_tweaker
        @failure_io = failure_io
        clear!
      end
      
      def add_behaviour(name)
        #TODO - @context_names.empty? tells the formatter whether this is the first context or not - that's a little slippery
        @formatter.add_behaviour(name, @context_names.empty?)
        @context_names << name
      end
      
      def example_started(name)
        @spec_names << name
        @formatter.example_started(name)
      end
      
      def example_finished(name, error=nil, failure_location=nil)
        if error.nil?
          spec_passed(name)
        else
          spec_failed(name, error, failure_location)
        end
      end

      def start(number_of_examples)
        clear!
        @start_time = Time.new
        @formatter.start(number_of_examples)
      end
  
      def end
        @end_time = Time.new
      end
  
      # Dumps the summary and returns the total number of failures
      def dump
        @formatter.start_dump
        dump_failures
        @formatter.dump_summary(duration, @spec_names.length, @failures.length)
        @failures.length
      end

      private
  
      def clear!
        @context_names = []
        @failures = []
        @spec_names = []
        @start_time = nil
        @end_time = nil
      end
  
      def dump_failures
        return if @failures.empty?
        @failures.inject(1) do |index, failure|
          @formatter.dump_failure(index, failure)
          index + 1
        end
      end

      def duration
        return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
        return "0.0"
      end

      def spec_passed(name)
        @formatter.spec_passed(name)
      end

      def spec_failed(name, error, failure_location)
        @backtrace_tweaker.tweak_backtrace(error, failure_location)
        behaviour_example_name = "#{@context_names.last} #{name}"
        @failure_io.puts(behaviour_example_name) unless @failure_io.nil?
        failure = Failure.new(behaviour_example_name, error)
        @failures << failure
        @formatter.spec_failed(name, @failures.length, failure)
      end
      
      class Failure
        attr_reader :exception
        
        def initialize(behaviour_example_name, exception)
          @behaviour_example_name = behaviour_example_name
          @exception = exception
        end

        def header
          if expectation_not_met?
            "'#{@behaviour_example_name}' FAILED"
          else
            "#{@exception.class.name} in '#{@behaviour_example_name}'"
          end
        end
        
        def expectation_not_met?
          @exception.is_a?(Spec::Expectations::ExpectationNotMetError)
        end

      end
    end
  end
end
