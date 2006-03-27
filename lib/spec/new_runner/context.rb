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
    attr_reader :name

    def initialize(name, runner=nil, &context_block)
      @specifications = []
      @name = name
      instance_exec(&context_block)
      $spec_runner.run(self) unless $spec_runner.nil?
      Spec::NewTextRunner.new(ARGV).run(self) if $spec_runner.nil?
    end

    def run(runner)
      @specifications.each do |specification|
        specification.run(@setup_block, @teardown_block)
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
      builder.add_context(self)
      @specifications.each { |spec| spec.add_to_builder(builder) }
    end
    
    def specification_count
      @specifications.length
    end
    
    def failure_count
      result = 0
      @specifications.each { |spec| result += 1 if spec.failed? }
      result
    end
  end

  class Specification
    attr_reader :name
  
    def initialize(name, &block)
      @name = name
      @block = block
    end

    def run(setup_block=nil, teardown_block=nil)
      # TODO: undefine run so the block doesn't have access to it
      begin
        instance_exec(&setup_block) unless setup_block.nil?
        instance_exec(&@block)
        instance_exec(&teardown_block) unless teardown_block.nil?
      rescue => @exception
      end
    end
    
    def failed?
      return true unless @exception.nil?
    end
    
    def exception
      @exception
    end
    
    def add_to_builder(builder)
      builder.add_spec(self)
    end
  end
end