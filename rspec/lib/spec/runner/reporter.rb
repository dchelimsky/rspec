module Spec
  module Runner
    class Reporter
      
      def initialize(formatter, backtrace_tweaker, failure_file=nil)
        @formatter = formatter
        @backtrace_tweaker = backtrace_tweaker
        @failure_file = failure_file
        @failure_io = StringIO.new if @failure_file
        clear!
      end
      
      def add_behaviour(name)
        @formatter.add_behaviour(name)
        @behaviour_names << name
      end
      
      def example_started(name)
        @formatter.example_started(name)
      end
      
      def example_finished(name, error=nil, failure_location=nil)
        @example_names << name
        if error.nil?
          example_passed(name)
        else
          example_failed(name, error, failure_location)
        end
      end

      def start(number_of_examples)
        clear!
        @start_time = Time.new
        @formatter.start(number_of_examples)
      end
  
      def end
        @end_time = Time.new
        if @failure_io
          @failure_io.rewind
          File.open(@failure_file, "w") do |io|
            io.write(@failure_io.read)
          end
        end
      end
  
      # Dumps the summary and returns the total number of failures
      def dump
        @formatter.start_dump
        dump_failures
        @formatter.dump_summary(duration, @example_names.length, @failures.length)
        @failures.length
      end

    private
  
      def clear!
        @behaviour_names = []
        @failures = []
        @example_names = []
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

      def example_passed(name)
        @formatter.example_passed(name)
      end

      def example_failed(name, error, failure_location)
        @backtrace_tweaker.tweak_backtrace(error, failure_location)
        example_name = "#{@behaviour_names.last} #{name}"
        @failure_io.puts(example_name) unless @failure_io.nil?
        failure = Failure.new(example_name, error)
        @failures << failure
        @formatter.example_failed(name, @failures.length, failure)
      end
      
      class Failure
        attr_reader :exception
        
        def initialize(example_name, exception)
          @example_name = example_name
          @exception = exception
        end

        def header
          if expectation_not_met?
            "'#{@example_name}' FAILED"
          else
            "#{@exception.class.name} in '#{@example_name}'"
          end
        end
        
        def expectation_not_met?
          @exception.is_a?(Spec::Expectations::ExpectationNotMetError)
        end

      end
    end
  end
end
