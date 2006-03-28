$LOAD_PATH.push File.dirname(__FILE__) + '/../..'

module Kernel  
  def context(name, &block)
    Spec::Context.new(name, &block) unless $generating_docs
    Spec::DocumentationContext.new(name, &block) if $generating_docs
  end
end

require 'spec/api'
require 'spec/new_runner/instance_exec'
require 'spec/new_runner/context_runner'

module Spec
  class Context
    def initialize(name, out=$stdout, &context_block)
      @specifications = []
      @name = name
      instance_exec(&context_block)
      Spec::ContextRunner.new(out).add_context(self).run if $context_runner.nil?
      $context_runner.add_context(self) unless $context_runner.nil?
    end

    def run(listener)
      @specifications.each do |specification|
        specification.run(listener, @setup_block, @teardown_block)
      end
    end

    def setup(&block)
      @setup_block = block
    end
  
    def teardown(&block)
      @teardown_block = block
    end
  
    def specify(spec_name, &block)
      @specifications << Specification.new(@name, spec_name, &block)
    end
    
  end
  
  class DocumentationContext
    def initialize(name, &proc)
      $out.puts "# #{name}"
      instance_exec(&proc)
    end

    def setup(&proc)
    end

    def teardown(&proc)
    end

    def specify(name, &proc)
      $out.puts "# * #{name}"
    end
  end

  class Specification
    def initialize(context_name, name, &block)
      @context_name = context_name
      @name = name
      @block = block
    end
    
    def run(listener, setup_block=nil, teardown_block=nil)
      execution_context = Object.new
      begin
        execution_context.instance_exec(&setup_block) unless setup_block.nil?
        execution_context.instance_exec(&@block)
        execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
        listener.pass(@context_name, @name) unless listener.nil?
      rescue => error
        listener.fail(@context_name, @name, error) unless listener.nil?
      end
    end
  end
end