module Spec
  class Specification
    
    def initialize(name, &block)
      @name = name
      @block = block
      @mocks = []
    end
    
    def run(listener=nil, setup_blocks=[], teardown_blocks=[])
      execution_context = ::Spec::Runner::ExecutionContext.new(self)
      begin
        setup_blocks.each do |setup_block|
          execution_context.instance_exec(&setup_block)
        end
        execution_context.instance_exec(&@block)
        teardown_blocks.each do |teardown_block|
          execution_context.instance_exec(&teardown_block)
        end
        @mocks.each do |mock|
          mock.__verify
        end
        listener.add_spec(@name) unless listener.nil?
      rescue => @error
        listener.add_spec(@name, @error) unless listener.nil?
      end
    end
    
    def run_docs(listener)
      listener.add_spec(@name)
    end
    
    def add_mock(mock)
      @mocks << mock
    end

  end
end