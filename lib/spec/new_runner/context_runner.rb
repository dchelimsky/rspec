require File.dirname(__FILE__) + '/simple_text_reporter'
# require File.dirname(__FILE__) + '/option_parser'

module Spec
  module Runner
    class ContextRunner
      
      def self.standalone context
        context_runner = ContextRunner.new(ARGV)
        context_runner.add_context context
        context_runner.run
      end
 
      def initialize(args)
        options = OptionParser.parse(args)
        @contexts = []
        @out = options.out
        @formatter = SimpleTextFormatter.new(@out, options.verbose)
      end
    
      def add_context(context)
        @contexts << context
        self
      end
    
      def run
        @formatter.start_time = Time.new
        @contexts.each do |context|
          context.run(@formatter)
        end
        @formatter.end_time = Time.new
        @formatter.dump
      end
    end
  end
end
