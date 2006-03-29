module Spec
  class Specification
    def initialize(context_name, name, &block)
      @context_name = context_name
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

    def describe_success(reporter)
      reporter.spec_name(@name)
    end
    
    def describe_failure(reporter)
      reporter.spec_name(@name, @error)
    end
  end
end