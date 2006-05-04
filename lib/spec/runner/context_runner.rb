require File.dirname(__FILE__) + '/../../spec'

module Spec
  module Runner
    class ContextRunner
      attr_reader :standalone
      
      def initialize(reporter, standalone, dry_run)
        @contexts = []
        @reporter = reporter
        @standalone = standalone
        @dry_run = dry_run
      end
    
      def add_context(context)
        @contexts << context
      end
      
      def number_of_specs
        @contexts.inject(0) {|sum, context| sum + context.number_of_specs}
      end
      
      # Runs all the contexts and specs and returns the total number of failures
      def run(exit_when_done=false)
        @reporter.start number_of_specs
        @contexts.each do |context|
          context.run(@reporter, @dry_run)
        end
        @reporter.end
        failure_count = @reporter.dump
        if(exit_when_done)
          exit_code = (failure_count == 0) ? 0 : 1
          exit!(exit_code)
        end
      end
    
    end
  end
end
