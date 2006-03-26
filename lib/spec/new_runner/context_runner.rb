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
    @errors = {}
    @name = name
    instance_exec(&block)
    
    @specifications.each do |specification|
      begin
        specification.run(@setup_block)
        STDOUT.write '.'
      rescue => e
        @errors[specification] = e
        STDOUT.write 'F'
      end
    end
    STDOUT.puts
    
    @errors.each do |specification, exception|
      puts "Failed: #{specification.name}"
      puts exception.backtrace.join("\n")
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
  attr_reader :name
  
  def initialize(name, &block)
    @name = name
    @block = block
  end

  def run(setup_block)
    # TODO: undefine run so the block doesn't have access to it
    instance_exec(&setup_block)
    instance_exec(&@block)
  end
end
