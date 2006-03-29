require 'spec/api'
require 'spec/new_runner/instance_exec'
require 'spec/new_runner/context_runner'

module Spec
  module Runner
    class Context
      def initialize(name, &context_block)
        @specifications = []
        @name = name
        instance_exec(&context_block)
        $context_runner.add_context(self) unless $context_runner.nil?
      end

      def run(reporter)
        reporter.context_started(self)
        @specifications.each do |specification|
          specification.run(reporter, @setup_block, @teardown_block)
        end
        reporter.context_ended(self)
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
    
      def describe(reporter)
        reporter.context_name(@name)
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
  end
end