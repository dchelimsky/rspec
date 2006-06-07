require File.dirname(__FILE__) + '/../../spec'

module Spec
  module Runner
    class ContextRunner
      attr_reader :standalone
      
      def initialize(reporter, standalone, dry_run, single_spec=nil)
        @contexts = []
        @reporter = reporter
        @standalone = standalone
        @dry_run = dry_run
        @single_spec = single_spec
      end
    
      def add_context(context)
        return if !@single_spec.nil? unless context.matches?(@single_spec)
        context.run_single_spec @single_spec if context.matches?(@single_spec)
        @contexts << context
      end
      
      def run(exit_when_done)
        @reporter.start(number_of_specs)
        @contexts.each do |context|
          context.run(@reporter, @dry_run)
        end
        @reporter.end
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
