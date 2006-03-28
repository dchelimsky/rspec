$LOAD_PATH.push File.dirname(__FILE__) + '/../..'

module Kernel  
  def context(name, &block)
    Spec::Context.new(name, &block)
  end
end

require 'spec/api'
require 'spec/new_runner/instance_exec'
require 'spec/new_runner/text_runner'

module Spec
  class Context
    def initialize(name, runner=nil, &context_block)
      @specifications = []
      @name = name
      instance_exec(&context_block)
      Spec::NewTextRunner.new(ARGV).add_context(self).run if $spec_runner.nil?
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

  class Specification
    def initialize(name, &block)
      @name = name
      @block = block
    end

    def run(listener, setup_block=nil, teardown_block=nil)
      # TODO: undefine run so the block doesn't have access to it
      begin
        instance_exec(&setup_block) unless setup_block.nil?
        instance_exec(&@block)
        instance_exec(&teardown_block) unless teardown_block.nil?
        listener.pass(@name)
      rescue => @exception
        listener.fail(@name, @exception)
      end
    end
    
    def add_to_builder(builder)
      builder.add_spec_name(@name)
    end
  end
end