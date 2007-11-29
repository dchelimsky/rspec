module Spec
  module Example
    class ExampleRunner
      attr_reader :options, :example_group_instance, :errors

      def initialize(options, example_group_instance)
        @options = options
        @example_group_instance = example_group_instance
        @errors = []
      end
      
      def run
        example = example_group_instance._example
        reporter.example_started(example)
        if dry_run
          example_group_instance.description = "NO NAME (Because of --dry-run)" if example_group_instance.use_generated_description?
          return reporter.example_finished(example, nil, example_group_instance.description)
        end

        location = nil
        Timeout.timeout(timeout) do
          before_each_ok = before_example
          example_ok = run_example if before_each_ok
          after_each_ok = after_example
          example_group_instance.description = description
          location = failure_location(before_each_ok, example_ok, after_each_ok)
          Spec::Matchers.clear_generated_description
        end

        reporter.example_finished(
          example,
          errors.first,
          location
        )
        ok?
      end

      protected

      def ok?
        @errors.empty? || @errors.all? {|error| error.is_a?(Spec::Example::ExamplePendingError)}
      end

      def failed?
        !ok?
      end

      def before_example
        example_group_instance.setup_mocks_for_rspec
        example_group_instance.run_before_each
        return ok?
      rescue Exception => e
        errors << e
        return false
      end

      def run_example
        example_group_instance.run
        return true
      rescue Exception => e
        errors << e
        return false
      end

      def after_example
        example_group_instance.run_after_each

        begin
          example_group_instance.verify_mocks_for_rspec
        ensure
          example_group_instance.teardown_mocks_for_rspec
        end

        return ok?
      rescue Exception => e
        errors << e
        return false
      end

      def failure_location(before_each_ok, example_ok, after_each_ok)
        return 'before(:each)' unless before_each_ok
        return description unless example_ok
        return 'after(:each)' unless after_each_ok
        return nil
      end

      def reporter
        @options.reporter
      end

      def timeout
        @options.timeout
      end
      
      def dry_run
        @options.dry_run
      end

      def description
        example = example_group_instance._example
        return example.description unless example_group_instance.use_generated_description?
        return Spec::Matchers.generated_description if Spec::Matchers.generated_description
        return failed? ? "NO NAME (Because of Error raised in matcher)" : "NO NAME (Because there were no expectations)"
      end

    end
  end
end
