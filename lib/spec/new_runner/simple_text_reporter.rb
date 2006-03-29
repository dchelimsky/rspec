module Spec
  module Runner
    class SimpleTextReporter
      def initialize(output=STDOUT,verbose=false)
        @output = output
        @context_names = []
        @errors = []
        @spec_names = []
        @verbose = verbose
      end
  
      def context_started(name)
        @context_names << name
        @output << "#{name}\n" if @verbose
      end
  
      def spec_passed(name)
        @spec_names << name
        @output << "- #{name}\n" if @verbose
        @output << '.' unless @verbose
      end

      def spec_failed(name, error)
        @spec_names << name
        @errors << error
        if @verbose
          @output << "- #{name} (FAILED)\n#{error.backtrace.join("\n")}\n\n"
        else
          @output << 'F'
        end
      end
  
      def start_time=(time)
        @start_time = time if @start_time.nil?
      end
  
      def end_time=(time)
        @end_time = time
      end
  
      def dump
        @output << "\n"
        dump_failures unless @verbose
        @output << "\n\n"
        @output << "Finished in " << (duration).to_s << " seconds\n\n"
        @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
        @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
        @output << "#{@errors.length} failure#{'s' unless @errors.length == 1 }"
        @output << "\n"
      end

      def dump_failures
        @output << "\n"
        @errors.inject(1) do |index, exception|
          @output << "\n\n" if index > 1
          @output << index.to_s << ") " 
          @output << "#{exception.message} (#{exception.class.name})\n"
          dump_backtrace(exception.backtrace)
          index + 1
        end
      end

      def dump_backtrace(trace)
        return if trace.nil?
        @output << trace.join("\n")
      end

      private
  
        def duration
          return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
          return "0.0"
        end

    end
  end
end