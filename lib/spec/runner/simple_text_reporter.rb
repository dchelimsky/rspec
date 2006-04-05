module Spec
  module Runner
    class SimpleTextReporter
      def initialize(output=STDOUT,verbose=false,backtrace_tweaker=BacktraceTweaker.new)
        @output = output
        @context_names = []
        @errors = []
        @spec_names = []
        @failures = []
        @verbose = verbose
        @backtrace_tweaker = backtrace_tweaker
      end
  
      def add_context(name, calling_line=nil)
        @output << "\n" if @context_names.empty? unless @verbose
        @output << "\n#{name}\n" if @verbose
        @context_names << [name, calling_line]
      end
      
      def add_spec(name, calling_line, errors=[])
        if errors.empty?
          spec_passed(name)
        else
          errors.each { |error| @backtrace_tweaker.tweak_backtrace(error, name) }
          # only show the first one (there might be more)
          spec_failed(name, calling_line, errors[0])
        end
      end
      
      def start
        @start_time = Time.new
      end
  
      def end
        @end_time = Time.new
      end
  
      def dump
        unless @verbose
          @output << "\n"
          dump_failures
          @output << "\n\n" unless @errors.empty?
        end
        @output << "\n" if @errors.empty?
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
        @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
        @output << "#{@errors.length} failure#{'s' unless @errors.length == 1 }"
        @output << "\n"
      end

      def dump_failures
        return if @errors.empty?
        @output << "\n"
        @failures.inject(1) do |index, failure|
          @output << "\n\n" if index > 1
          @output << index.to_s << ") "
          @output << "Context: #{failure[0]} - #{failure[1]}\n"
          @output << "Specification: #{failure[2]} - #{failure[3]}\n"
          @output << "Expectation: #{failure[4].message} (#{failure[4].class.name})\n"
          dump_backtrace(failure[4].backtrace)
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

        def spec_failed(name, calling_line, error)
          @spec_names << name
          @errors << error
          @failures << [@context_names.last[0], @context_names.last[1], name, calling_line, error]
          if @verbose
            @output << "- #{name} (FAILED)\n#{error.message} (#{error.class.name})\n#{error.backtrace.join("\n")}\n"
          else
            @output << 'F'
          end
        end

    end
  end
end