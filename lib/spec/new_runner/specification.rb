module Spec
  class Specification
    def initialize(name, &block)
      @name = name
      @block = block
    end
    
    def run(reporter=nil, setup_block=nil, teardown_block=nil)
      execution_context = Object.new
      begin
        execution_context.instance_exec(&setup_block) unless setup_block.nil?
        execution_context.instance_exec(&@block)
        execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
        reporter.spec_passed(self) unless reporter.nil?
      rescue => @error
        reporter.spec_failed(self, @error) unless reporter.nil?
      end
    end

  end
end