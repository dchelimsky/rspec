module Spec
  module Runner
    class Specification
    
      def initialize(name, &block)
        @name = name
        @block = block
        @mocks = []
        @errors = []
      end
    
      def run(reporter=nil, setup_block=nil, teardown_block=nil)
        execution_context = ::Spec::Runner::ExecutionContext.new(self)
        begin
          execution_context.instance_exec(&setup_block) unless setup_block.nil?
          passed_setup = true
          execution_context.instance_exec(&@block)
          passed_spec = true
        rescue => e
          @errors << e
        end

        begin
          execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
          passed_teardown = true
          @mocks.each do |mock|
            mock.__verify
          end
        rescue => e
          @errors << e
        end

        reporter.add_spec(@name, @errors, failure_location(passed_setup, passed_spec, passed_teardown)) unless reporter.nil?
      end
    
      def run_docs(reporter)
        reporter.add_spec(@name)
      end
      
      def failure_location(passed_setup, passed_spec, passed_teardown)
        return 'setup' unless passed_setup
        return @name unless passed_spec
        return 'teardown' unless passed_teardown
      end
    
      def add_mock(mock)
        @mocks << mock
      end
    end
  end
end