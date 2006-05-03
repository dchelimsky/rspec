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
      
      def run
        @reporter.start number_of_specs
        @contexts.each do |context|
          context.run(@reporter, @dry_run)
        end
        @reporter.end
        @reporter.dump
      end
    
    end
  end
end
