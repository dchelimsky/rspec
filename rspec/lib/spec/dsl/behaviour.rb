require 'forwardable'

module Spec
  module DSL
    class BehaviourEvalModule < Module; end
    class Behaviour
      extend Forwardable
      
      def_delegator :@context_eval_module, :include
      def_delegator :@context_eval_module, :inherit
      def_delegator :@context_eval_module, :it
      def_delegator :@context_eval_module, :context_setup
      def_delegator :@context_eval_module, :setup
      def_delegator :@context_eval_module, :teardown
      def_delegator :@context_eval_module, :context_teardown

      alias :specify :it

      def initialize(description, &context_block)
        @description = description

        @context_eval_module = BehaviourEvalModule.new
        @context_eval_module.extend BehaviourEval::ModuleMethods
        @context_eval_module.include BehaviourEval::InstanceMethods
        before_context_eval
        @context_eval_module.class_eval(&context_block)
      end

      def before_context_eval
      end
      
      def run(reporter, dry_run=false, reverse=false)
        plugin_mock_framework
        reporter.add_behaviour(@description)
        prepare_execution_context_class
        errors = run_context_setup(reporter, dry_run)

        specs = reverse ? examples.reverse : examples
        specs.each do |example|
          example_execution_context = execution_context(example)
          example_execution_context.copy_instance_variables_from(@once_only_execution_context_instance, []) unless context_setup_block.nil?
          example.run(reporter, setup_block, teardown_block, dry_run, example_execution_context)
        end unless errors.length > 0
        
        run_context_teardown(reporter, dry_run)
      end

      def number_of_specs
        examples.length
      end

      def matches?(full_description)
        matcher ||= ExampleMatcher.new(@description)
        examples.each do |spec|
          return true if spec.matches?(matcher, full_description)
        end
        return false
      end

      def run_single_spec(full_description)
        return if @description == full_description
        matcher = ExampleMatcher.new(@description)
        examples.reject! do |spec|
          !spec.matches?(matcher, full_description)
        end
      end

      def methods
        my_methods = super
        my_methods |= @context_eval_module.methods
        my_methods
      end

    protected

      def_delegator :@context_eval_module, :context_setup_block
      def_delegator :@context_eval_module, :context_teardown_block
      def_delegator :@context_eval_module, :examples
      def_delegator :@context_eval_module, :setup_block
      def_delegator :@context_eval_module, :teardown_block
      def_delegator :@context_eval_module, :context_modules
      def_delegator :@context_eval_module, :execution_context_class
      
      def method_missing(sym, *args, &block)
        @context_eval_module.send(sym, *args, &block)
      end

      def prepare_execution_context_class
        weave_in_context_modules
        execution_context_class
      end

      def weave_in_context_modules
        mods = context_modules
        context_eval_module = @context_eval_module
        execution_context_class.class_eval do
          include context_eval_module
          mods.each do |mod|
            include mod
          end
        end
      end

      def execution_context(example)
        execution_context_class.new(example)
      end

      def run_context_setup(reporter, dry_run)
        errors = []
        unless dry_run
          begin
            @once_only_execution_context_instance = execution_context(nil)
            @once_only_execution_context_instance.instance_eval(&context_setup_block)
          rescue => e
            errors << e
            location = "context_setup"
            reporter.spec_finished(location, e, location) if reporter
          end
        end
        errors
      end
      
      def run_context_teardown(reporter, dry_run)
        unless dry_run
          begin 
            @once_only_execution_context_instance ||= execution_context(nil) 
            @once_only_execution_context_instance.instance_eval(&context_teardown_block) 
          rescue => e
            location = "context_teardown"
            reporter.spec_finished(location, e, location) if reporter
          end
        end
      end
      
      def plugin_mock_framework
        require File.expand_path(File.join(File.dirname(__FILE__), "..", "plugins","mock_framework.rb"))
        include Spec::Plugins::MockMethods
      end

    end
  end
end
