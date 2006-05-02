module Spec
  module Runner
    class SimpleTextReporter
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