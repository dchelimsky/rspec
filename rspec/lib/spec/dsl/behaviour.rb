module Spec
  module DSL
    class EvalModule < Module; end
    class Behaviour
      extend BehaviourCallbacks
      
      def initialize(description, &context_block)
        @description = description

        @eval_module = EvalModule.new
        @eval_module.extend BehaviourEval::ModuleMethods
        @eval_module.include BehaviourEval::InstanceMethods
        before_eval
        @eval_module.class_eval(&context_block)
      end

      def before_eval
      end
      
      def run(reporter, dry_run=false, reverse=false, timeout=nil)
        reporter.add_behaviour(description)
        prepare_execution_context_class
        errors = run_before_all(reporter, dry_run)

        specs = reverse ? examples.reverse : examples
        example_execution_context = nil
        specs.each do |example|
          example_execution_context = execution_context(example)
          example_execution_context.copy_instance_variables_from(@before_and_after_all_context_instance) unless before_all_proc.nil?
          example.run(reporter, before_each_proc, after_each_proc, dry_run, example_execution_context, timeout)
        end unless errors.length > 0
        
        @before_and_after_all_context_instance.copy_instance_variables_from(example_execution_context) unless after_all_proc.nil?
        run_after_all(reporter, dry_run)
      end

      def number_of_examples
        examples.length
      end

      def matches?(specified_examples)
        matcher ||= ExampleMatcher.new(description)

        examples.each do |example|
          return true if example.matches?(matcher, specified_examples)
        end
        return false
      end

      def retain_examples_matching!(specified_examples)
        return if specified_examples.index(description)
        matcher = ExampleMatcher.new(description)
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

      # Messages that this class does not understand
      # are passed directly to the @eval_module.
      def method_missing(sym, *args, &block)
        @eval_module.send(sym, *args, &block)
      end

      def prepare_execution_context_class
        plugin_mock_framework
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

      def run_before_all(reporter, dry_run)
        errors = []
        unless dry_run
          begin
            @before_and_after_all_context_instance = execution_context(nil)
            @before_and_after_all_context_instance.instance_eval(&before_all_proc)
          rescue => e
            errors << e
            location = "before(:all)"
            reporter.example_finished(location, e, location) if reporter
          end
        end
        errors
      end
      
      def run_after_all(reporter, dry_run)
        unless dry_run
          begin 
            @before_and_after_all_context_instance ||= execution_context(nil) 
            @before_and_after_all_context_instance.instance_eval(&after_all_proc) 
          rescue => e
            location = "after(:all)"
            reporter.example_finished(location, e, location) if reporter
          end
        end
      end
      
      def plugin_mock_framework
        case mock_framework = Spec::Runner.configuration.mock_framework
        when Module
          include mock_framework
        else
          require Spec::Runner.configuration.mock_framework
          include Spec::Plugins::MockFramework
        end
      end
      
      def description
        @description.respond_to?(:description) ? @description.description : @description
      end
      
      def described_type
        @description.respond_to?(:described_type) ? @description.described_type : nil
      end

    end
  end
end
