module Spec
  module Runner
    class Context
      @@context_runner = nil
      
      def self.context_runner= runner
        @@context_runner = runner
      end
      
      def initialize(name, &context_block)
        @setup_block = nil
        @teardown_block = nil
        @specifications = []
        @name = name
        instance_exec(&context_block)
        ContextRunner.standalone(self) if @@context_runner.nil?
        @@context_runner.add_context(self) unless @@context_runner.nil?
      end

      def run(reporter)
        reporter.add_context(@name)
        @specifications.each do |specification|
          specification.run(reporter, @setup_block, @teardown_block)
        end
      end
      
      def run_docs(reporter)
        reporter.add_context(@name)
        @specifications.each do |specification|
          specification.run_docs(reporter)
        end
      end

      def setup(&block)
        @setup_block = block
      end
  
      def teardown(&block)
        @teardown_block = block
      end
  
      def specify(spec_name, &block)
        @specifications << Specification.new(spec_name, &block)
      end
    end
  end
end