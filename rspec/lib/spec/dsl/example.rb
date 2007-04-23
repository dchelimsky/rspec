require 'timeout'

module Spec
  module DSL
    class Example

      class << self
        callback_events :before_setup, :after_teardown
      end

      callback_events :before_setup, :after_teardown

      def initialize(description, options={}, &example_block)
        @from = caller(0)[3]
        @options = options
        @example_block = example_block
        @description = description
        setup_auto_generated_description
      end
      
      def setup_auto_generated_description
        description_generated = lambda { |desc| @generated_description = desc }
        before_setup do
          Spec::Matchers.register_callback(:description_generated, description_generated)
        end
        after_teardown do
          Spec::Matchers.unregister_callback(:description_generated, description_generated)
        end
      end

      def run(reporter, before_each_block, after_each_block, dry_run, execution_context, timeout=nil)
        reporter.example_started(description)
        return reporter.example_finished(description) if dry_run

        errors = []
        location = nil
        Timeout.timeout(timeout) do
          setup_ok = setup_example(execution_context, errors, &before_each_block)
          example_ok = run_example(execution_context, errors) if setup_ok
          teardown_ok = teardown_example(execution_context, errors, &after_each_block)
          location = failure_location(setup_ok, example_ok, teardown_ok)
        end

        ExampleShouldRaiseHandler.new(@from, @options).handle(errors)
        reporter.example_finished(description, errors.first, location) if reporter
      end
      
      def matches?(matcher, specified_examples)
        matcher.example_desc = description
        matcher.matches?(specified_examples)
      end
      
    private
      def description
        @description == :__generate_description ? generated_description : @description
      end
      
      def generated_description
        @generated_description || "NAME NOT GENERATED"
      end
      
      def setup_example(execution_context, errors, &before_each_block)
        notify_before_setup(errors)
        setup_mocks(execution_context)
        execution_context.instance_eval(&before_each_block) if before_each_block
        return errors.empty?
      rescue => e
        errors << e
        return false
      end

      def run_example(execution_context, errors)
        begin
          execution_context.instance_eval(&@example_block)
          return true
        rescue Exception => e
          errors << e
          return false
        end
      end

      def teardown_example(execution_context, errors, &after_each_block)
        execution_context.instance_eval(&after_each_block) if after_each_block
        begin
          verify_mocks(execution_context)
        ensure
          teardown_mocks(execution_context)
        end
        notify_after_teardown(errors)
        return errors.empty?
      rescue => e
        errors << e
        return false
      end
      
      def setup_mocks(execution_context)
        execution_context.setup_mocks_for_rspec if execution_context.respond_to?(:setup_mocks_for_rspec)
      end
      
      def verify_mocks(execution_context)
        execution_context.verify_mocks_for_rspec if execution_context.respond_to?(:verify_mocks_for_rspec)
      end
      
      def teardown_mocks(execution_context)
        execution_context.teardown_mocks_for_rspec if execution_context.respond_to?(:teardown_mocks_for_rspec)
      end
      
      def notify_before_setup(errors)
        notify_class_callbacks(:before_setup, self, &append_errors(errors))
        notify_callbacks(:before_setup, self, &append_errors(errors))
      end
      
      def notify_after_teardown(errors)
        notify_callbacks(:after_teardown, self, &append_errors(errors))
        notify_class_callbacks(:after_teardown, self, &append_errors(errors))
      end
      
      def append_errors(errors)
        proc {|error| errors << error}
      end
      
      def failure_location(setup_ok, example_ok, teardown_ok)
        return 'setup' unless setup_ok
        return description unless example_ok
        return 'teardown' unless teardown_ok
      end
    end
  end
end
