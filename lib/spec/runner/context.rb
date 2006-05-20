module Spec
  module Runner
    class Context
      def initialize(name, &context_block)
        @setup_block = nil
        @teardown_block = nil
        @specifications = []
        @name = name
        instance_exec(&context_block)
      end

      def run(reporter, dry_run=false)
        reporter.add_context(@name)
        @specifications.each do |specification|
          specification.run(reporter, @setup_block, @teardown_block, dry_run)
        end
      end

      def setup(&block)
        @setup_block = block
      end
  
      def teardown(&block)
        @teardown_block = block
      end
  
      def specify(spec_name, &block)
        @specifications << Specification.new(spec_name, &block)
      end
      
      def number_of_specs
        @specifications.length
      end
      
      def matches? name, matcher=nil
        matcher ||= SpecMatcher.new name, @name
        @specifications.each do |spec|
          return true if spec.matches_matcher? matcher 
        end
        return false
      end
      
      def run_single_spec name
        return if @name == name
        matcher = SpecMatcher.new name, @name
        @specifications.reject! do |spec|
          !spec.matches_matcher? matcher
        end
      end
    end
  end
end
