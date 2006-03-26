$LOAD_PATH.push File.dirname(__FILE__) + '/../..'

module Kernel  
  def context(name, &block)
    Context.new(name, &block)
  end
end

require 'spec/api'
require 'spec/new_runner/instance_exec'
require 'spec/new_runner/text_runner'

class Context
  def initialize(name, runner=nil, &block)
    @specifications = []
    @errors = {}
    @name = name
    @context_block = block
    instance_exec(&@context_block)
    Spec::TextRunner.new.run(self) if runner.nil?
  end

  def run(runner)
    runner.spec(self)
    @specifications.each do |specification|
      begin
        specification.run(@setup_block, @teardown_block)
        runner.pass(specification)
      rescue => e
        runner.failure(specification, e)
      end
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
end

class Specification
  attr_reader :name
  
  def initialize(name, &block)
    @name = name
    @block = block
  end

  def run(setup_block, teardown_block)
    # TODO: undefine run so the block doesn't have access to it
    instance_exec(&setup_block)
    instance_exec(&@block)
    instance_exec(&teardown_block)
  end
end
