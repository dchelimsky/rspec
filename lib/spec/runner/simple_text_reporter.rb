module Spec
  module Runner
    class SimpleTextReporter
      def initialize(output=STDOUT,verbose=false,backtrace_tweaker=QuietBacktraceTweaker.new)
        @output = output
        @context_names = []
        @errors = []
        @spec_names = []
        @verbose = verbose
        @backtrace_tweaker = backtrace_tweaker
      end
  
      def add_context(name)
        @output << "\n" if @context_names.empty? unless @verbose
        @output << "\n#{name}\n" if @verbose
        @context_names << name
      end
      
      def add_spec(name, errors=[], failure_location=nil)
        if errors.empty?
          spec_passed(name)
        else
          failure_location = "[#{failure_location}]" if ["setup", "teardown"].include? failure_location
          errors.each { |error| @backtrace_tweaker.tweak_backtrace(error, "#{@context_names.last} #{failure_location}") }
          # only show the first one (there might be more)
          spec_failed(name, errors[0])
        end
      end
      
      def start(number_of_specs=0)
        @start_time = Time.new
      end
  
      def end
        @end_time = Time.new
      end
  
      def dump
        @output << "\n"
        dump_errors
        @output << "\n\n" unless @errors.empty?
        @output << "\n" if @errors.empty?
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
        @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
        @output << "#{@errors.length} failure#{'s' unless @errors.length == 1 }"
        @output << "\n"
      end

      def dump_errors
        return if @errors.empty?
        @output << "\n"
        @errors.inject(1) do |index, error|
          @output << "\n\n" if index > 1
          @output << index.to_s << ")\n"
          @output << "#{error.message} (#{error.class.name})\n"
          dump_backtrace(error.backtrace)
          index + 1
        end
      end

      def dump_backtrace(trace)
        @output << trace.join("\n") unless trace.nil?
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

        def spec_failed(name, error)
          @spec_names << name
          @errors << error
          @output << "- #{name} (FAILED - #{@errors.length})\n" if @verbose
          @output << 'F' unless @verbose
        end

    end
    
  end
end