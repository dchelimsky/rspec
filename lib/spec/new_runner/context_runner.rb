$LOAD_PATH.push File.dirname(__FILE__) + '/../..'

module Kernel  
  def context(name, &block)
    Context.new(name, &block)
  end
end

require 'spec/api'
require 'spec/new_runner/instance_exec'

class Context
  def initialize(name, &block)
    @specifications = []
    @name = name
    instance_exec(&block)
    
    @specifications.each do |specification|
      specification.run(@setup_block)
    end
  end

  def setup(&block)
    @setup_block = block
  end
  
  def specify(name, &block)
    @specifications << Specification.new(name, &block)
  end
end

class Specification
  def initialize(name, &block)
    @name = name
    @block = block
  end
  
  def run(setup_block)
    instance_exec(&setup_block)
    instance_exec(&@block)
  end
end
