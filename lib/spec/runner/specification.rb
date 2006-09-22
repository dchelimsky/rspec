module Spec
  module Runner
    class Specification

      def initialize(name, &block)
        @name = name
        @block = block
        @mocks = []
        @stub_space = Stubs::StubSpace.new
      end

      def run(reporter=nil, setup_block=nil, teardown_block=nil, dry_run=false, execution_context=nil)
        reporter.spec_started(@name)
        return reporter.spec_finished(@name) if dry_run
        execution_context = execution_context || ::Spec::Runner::ExecutionContext.new(self)
        errors = []
        begin
          execution_context.instance_exec(&setup_block) unless setup_block.nil?
          setup_ok = true
          execution_context.instance_exec(&@block)
          spec_ok = true
        rescue => e
          errors << e
        end

        begin
          execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
          teardown_ok = true
          @mocks.each do |mock|
            mock.__verify
          end
          @stub_space.registry.clear!
        rescue => e
          errors << e
        end

        reporter.spec_finished(@name, errors.first, failure_location(setup_ok, spec_ok, teardown_ok)) unless reporter.nil?
      end

      def add_mock(mock)
        @mocks << mock
      end

      def stub_space
        @stub_space
      end
      
      def matches_matcher?(matcher)
        matcher.matches? @name 
      end
            
      private
      
      def failure_location(setup_ok, spec_ok, teardown_ok)
        return 'setup' unless setup_ok
        return @name unless spec_ok
        return 'teardown' unless teardown_ok
      end
    
    end
  end
end