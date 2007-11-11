module Spec
  module DSL
    class ExampleRunner
      attr_reader :options, :example_group_instance, :errors, :example
      private :example

      def initialize(options, example_group_instance)
        @options = options
        @example_group_instance = example_group_instance
        @example = example_group_instance.example
        @errors = []
      end
      
      def run
        reporter.example_started(example)
        if dry_run
          example.description = "NO NAME (Because of --dry-run)" if example.description == :__generate_description
          return reporter.example_finished(example, nil, example.description)
        end

        location = nil
        Timeout.timeout(timeout) do
          before_each_ok = before_example
          example_ok = run_example if before_each_ok
          after_each_ok = after_example
          example.description = description
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

      def ok?
        @errors.empty? || @errors.all? {|error| error.is_a?(Spec::DSL::ExamplePendingError)}
      end

      def failed?
        !ok?
      end

      protected
      def before_example
        setup_mocks
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
          verify_mocks
        ensure
          teardown_mocks
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

      def from
        example.from
      end

      def description
        return example.description unless example.use_generated_description?
        return Spec::Matchers.generated_description if Spec::Matchers.generated_description
        return "NO NAME (Because of Error raised in matcher)" if failed?
        "NO NAME (Because there were no expectations)"
      end

      def setup_mocks
        if example_group_instance.respond_to?(:setup_mocks_for_rspec)
          example_group_instance.setup_mocks_for_rspec
        end
      end

      def verify_mocks
        if example_group_instance.respond_to?(:verify_mocks_for_rspec)
          example_group_instance.verify_mocks_for_rspec
        end
      end

      def teardown_mocks
        if example_group_instance.respond_to?(:teardown_mocks_for_rspec)
          example_group_instance.teardown_mocks_for_rspec
        end
      end
    end
  end
end
