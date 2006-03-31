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
  
      def add_context(name)
        @context_names << name
        @output << "#{name}\n" if @verbose
      end
      
      def add_spec(name, error=nil)
        spec_passed(name) if error.nil?
        spec_failed(name, error) unless error.nil?
      end
  
      def start
        @start_time = Time.new
      end
  
      def end
        @end_time = Time.new
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
        @errors.inject(1) do |index, error|
          @output << "\n\n" if index > 1
          @output << index.to_s << ") " 
          @output << "#{error.message} (#{error.class.name})\n"
          dump_backtrace(error.backtrace)
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

        def spec_passed(name)
          @spec_names << name
          @output << "- #{name}\n" if @verbose
          @output << '.' unless @verbose
        end

        def spec_failed(name, error)
          @spec_names << name
          @errors << error
          if @verbose
            @output << "- #{name} (FAILED)\n#{error.message} (#{error.class.name})\n#{error.backtrace.join("\n")}\n\n"
          else
            @output << 'F'
          end
        end

    end
  end
end