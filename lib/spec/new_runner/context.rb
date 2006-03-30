module Spec
  module Runner
    class Context
      @@context_runner = nil
      
      def self.context_runner= runner
        @@context_runner = runner
      end
      
      def initialize(name, &context_block)
        @setup_blocks = []
        @teardown_blocks = []
        @specifications = []
        @name = name
        instance_exec(&context_block)
        @@context_runner.add_context(self) unless @@context_runner.nil?
        ContextRunner.standalone(self) if @@context_runner.nil?
      end

      def run(reporter)
        reporter.context_started(@name)
        @specifications.each do |specification|
          specification.run(reporter, @setup_blocks, @teardown_blocks)
        end
      end

      def setup(&block)
        @setup_blocks << block
      end
  
      def teardown(&block)
        @teardown_blocks << block
      end
  
      def specify(spec_name, &block)
        @specifications << Specification.new(spec_name, &block)
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