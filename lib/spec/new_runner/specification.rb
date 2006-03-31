module Spec
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
      rescue => e
        @errors << e
      end

      begin
        execution_context.instance_exec(&@block)
      rescue => e
        @errors << e
      end

      begin
        execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
      rescue => e
        @errors << e
      end

      begin
        @mocks.each do |mock|
          mock.__verify
        end
      rescue => e
        @errors << e
      end

      reporter.add_spec(@name, @errors) unless reporter.nil?
    end
    
    def run_docs(reporter)
      reporter.add_spec(@name)
    end
    
    def add_mock(mock)
      @mocks << mock
    end

  end
end