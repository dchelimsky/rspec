module Spec
  module Runner
    class SimpleTextReporter
      def initialize(output=STDOUT,verbose=false,backtrace_tweaker=QuietBacktraceTweaker.new)
        @output = output
        @context_names = []
        @failures = []
        @spec_names = []
        @verbose = verbose
        @backtrace_tweaker = backtrace_tweaker
      end
  
      def add_context(name)
        @output << "\n" if @context_names.empty? unless @verbose
        @output << "\n#{name}\n" if @verbose
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
        @output << "\n" unless @verbose
        dump_failures
        @output << "\n"
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
        @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
        @output << "#{@failures.length} failure#{'s' unless @failures.length == 1 }"
        @output << "\n"
      end

      def dump_failures
        return if @failures.empty?
        @failures.inject(1) do |index, failure|
          @output << "\n"
          @output << index.to_s << ")\n"
          @output << "#{failure.header}\n"
          @output << "#{failure.message}\n"
          @output << "#{failure.backtrace}\n"
          index + 1
        end
      end

      private
  
      def duration
        return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
        return "0.0"
      end

      def spec_passed(name)
        @spec_names << name
        @output << "- #{name}\n" if @verbose
        @output << '.' unless @verbose
      end

      def spec_failed(name, failure)
        @spec_names << name
        @failures << failure
        @output << "- #{name} (FAILED - #{@failures.length})\n" if @verbose
        @output << 'F' unless @verbose
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