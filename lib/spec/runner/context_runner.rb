require File.dirname(__FILE__) + '/../../spec'

module Spec
  module Runner
    class ContextRunner
      
      def self.standalone(context, args=ARGV)
        context_runner = ContextRunner.new(args, true)
        context_runner.add_context context
        context_runner.run
      end
 
      def initialize(args, standalone=false, err=$stderr)
        @options = OptionParser.parse(args, standalone, err)
        @contexts = []
        @out = @options.out
        @out = File.open(@out, 'w') if @out.is_a? String
        @doc = @options.doc
        register_listener(@doc ? RDocFormatter.new(@out) : Reporter.new(@out, options.verbose, @options.backtrace_tweaker))
      end
      
      def options
        @options
      end
      
      def register_listener(listener)
        @listener = listener
      end
    
      def add_context(context)
        @contexts << context
        self
      end
      
      def number_of_specs
        @contexts.inject(0) {|sum, context| sum + context.number_of_specs}
      end
      
      def run
        run_specs unless @doc
        run_docs if @doc
      end
    
      private
      
      def run_specs
        @listener.start number_of_specs
        @contexts.each do |context|
          context.run(@listener)
        end
        @listener.end
        @listener.dump
      end
    
      def run_docs
        @contexts.each do |context|
          context.run_docs(@listener)
        end
      end

    end
  end
end
