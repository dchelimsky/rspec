module Spec
  module Runner
    class SimpleTextFormatter
      def initialize(output=STDOUT,verbose=false)
        @output = output
        @context_names = []
        @contexts = []
        @specs = []
        @errors = []
        @spec_names = []
        @failures = Hash.new
        @verbose = verbose
      end
  
      def context_started(context)
        context.describe(self)
        @contexts << context
      end
  
      def context_name(name)
        @output << "#{name}\n" if @verbose
      end
  
      def spec_passed(spec)
        spec.describe_success(self)
        @specs << spec
      end

      def spec_failed(spec, error)
        spec.describe_failure(self)
        @specs << spec
        @errors << error
      end
  
      def spec_name(name, error=nil)
        if @verbose
          @output << "- #{name}\n" if error.nil?
          @output << "- #{name} (FAILED)\n#{error.backtrace.join("\n")}\n\n" unless error.nil?
        else
          @output << '.' if error.nil?
          @output << 'F' unless error.nil?
        end
      end
  
      def context_ended(context)
      end
  
      # old
  
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
        @output << "#{@contexts.length} context#{'s' unless @contexts.length == 1 }, "
        @output << "#{@specs.length} specification#{'s' unless @specs.length == 1 }, "
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