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
    def initialize(name, runner=nil, &context_block)
      @specifications = []
      @name = name
      instance_exec(&context_block)
      Spec::ContextRunner.new(STDOUT).add_context(self).run if $spec_runner.nil?
      $spec_runner.add_context(self) unless $spec_runner.nil?
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
  
    def specify(name, &block)
      @specifications << Specification.new(name, &block)
    end
    
    def add_to_builder(builder)
      builder.add_context_name(@name)
      @specifications.each { |spec| spec.add_to_builder(builder) }
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
    def initialize(name, &block)
      @name = name
      @block = block
    end
    
    def passed?
      @exception.nil?
    end

    def run(listener, setup_block=nil, teardown_block=nil)
      execution_context = Object.new
      begin
        execution_context.instance_exec(&setup_block) unless setup_block.nil?
        execution_context.instance_exec(&@block)
        execution_context.instance_exec(&teardown_block) unless teardown_block.nil?
        listener.pass(@name) unless listener.nil?
      rescue => @exception
        listener.fail(@name, @exception) unless listener.nil?
      end
    end
    
    def add_to_builder(builder)
      builder.add_spec_name(@name)
    end
  end
end