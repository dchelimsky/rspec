require 'forwardable'

module Spec
  module DSL
    class EvalModule < Module; end
    class Behaviour
      extend Forwardable
      
      def_delegator :@eval_module, :include
      def_delegator :@eval_module, :inherit
      def_delegator :@eval_module, :it
      def_delegator :@eval_module, :context_setup
      def_delegator :@eval_module, :setup
      def_delegator :@eval_module, :teardown
      def_delegator :@eval_module, :context_teardown

      alias :specify :it

      def initialize(description, &context_block)
        @description = description

        @eval_module = EvalModule.new
        @eval_module.extend BehaviourEval::ModuleMethods
        @eval_module.include BehaviourEval::InstanceMethods
        before_eval
        @eval_module.class_eval(&context_block)
      end

      # TODO - shouldn't this just be a callback?
      def before_eval
      end
      
      def run(reporter, dry_run=false, reverse=false, timeout=nil)
        plugin_mock_framework
        reporter.add_behaviour(@description)
        prepare_execution_context_class
        errors = run_context_setup(reporter, dry_run)

        specs = reverse ? examples.reverse : examples
        specs.each do |example|
          example_execution_context = execution_context(example)
          example_execution_context.copy_instance_variables_from(@once_only_execution_context_instance, []) unless context_setup_block.nil?
          example.run(reporter, setup_block, teardown_block, dry_run, example_execution_context, timeout)
        end unless errors.length > 0
        
        run_context_teardown(reporter, dry_run)
      end

      def number_of_examples
        examples.length
      end

      def matches?(specified_examples)
        matcher ||= ExampleMatcher.new(@description)

        examples.each do |example|
          return true if example.matches?(matcher, specified_examples)
        end
        return false
      end

      def retain_examples_matching!(specified_examples)
        return if specified_examples.index(@description)
        matcher = ExampleMatcher.new(@description)
        examples.reject! do |example|
          !example.matches?(matcher, specified_examples)
        end
      end

      def methods
        my_methods = super
        my_methods |= @eval_module.methods
        my_methods
      end

    protected

      def_delegator :@eval_module, :context_setup_block
      def_delegator :@eval_module, :context_teardown_block
      def_delegator :@eval_module, :examples
      def_delegator :@eval_module, :setup_block
      def_delegator :@eval_module, :teardown_block
      def_delegator :@eval_module, :context_modules
      def_delegator :@eval_module, :execution_context_class

      # Messages that this class does not understand
      # are passed directly to the @eval_module, which
      # is the scope in which user-defined helper methods
      # can be found.
      def method_missing(sym, *args, &block)
        @eval_module.send(sym, *args, &block)
      end

      def prepare_execution_context_class
        weave_in_context_modules
        execution_context_class
      end

      def weave_in_context_modules
        mods = context_modules
        eval_module = @eval_module
        execution_context_class.class_eval do
          include eval_module
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
            reporter.example_finished(location, e, location) if reporter
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
            reporter.example_finished(location, e, location) if reporter
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
