require File.dirname(__FILE__) + '/../../spec'

module Spec
  module Runner
    class ContextRunner
      
      def initialize(options)
        @contexts = []
        @reporter = options.reporter
        @dry_run = options.dry_run
        @spec_name = options.spec_name
      end
    
      def add_context(context)
        return if !@spec_name.nil? unless context.matches?(@spec_name)
        context.run_single_spec(@spec_name) if context.matches?(@spec_name)
        @contexts << context
      end
      
      def run(exit_when_done)
        @reporter.start(number_of_specs)
        begin
          @contexts.each do |context|
            context.run(@reporter, @dry_run)
          end
        rescue Interrupt
        ensure
          @reporter.end
        end
        failure_count = @reporter.dump
        
        if(exit_when_done)
          exit_code = (failure_count == 0) ? 0 : 1
          exit(exit_code)
        end
      end
    
      def number_of_specs
        @contexts.inject(0) {|sum, context| sum + context.number_of_specs}
      end
      
    end
  end
end
