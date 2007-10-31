module Spec
  module DSL
    # TODO: We need RDoc here anyway (Aslak) 
    class ExampleRunner
      attr_reader :options, :example, :example_definition, :errors

      def initialize(options, example)
        @options = options
        @example = example
        @example_definition = example.rspec_definition
        @errors = []
        @behaviour = example.class
      end

      def run
        reporter.example_started(example_definition)
        if dry_run
          example_definition.description = "NO NAME (Because of --dry-run)" if example_definition.description == :__generate_description
          return reporter.example_finished(example_definition, nil, example_definition.description)
        end

        location = nil
        Timeout.timeout(timeout) do
          before_each_ok = before_example
          example_ok = run_example if before_each_ok
          after_each_ok = after_example
          example_definition.description = description
          location = failure_location(before_each_ok, example_ok, after_each_ok)
          Spec::Matchers.clear_generated_description
        end

        if should_raise
          ShouldRaiseHandler.new(from, should_raise).handle(errors)
        end
        reporter.example_finished(
          example_definition,
          errors.first,
          location,
          example_definition.pending?
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
        example.before_each
        return ok?
      rescue Exception => e
        errors << e
        return false
      end

      def run_example
        if example_block
          example.run_example
          return true
        else
          raise ExamplePendingError
        end
      rescue Exception => e
        errors << e
        return false
      end

      def after_example(&behaviour_after_each)
        example.after_each

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

      def example_block
        example_definition.example_block
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
        example_definition.from
      end

      def should_raise
        example_definition.should_raise
      end

      def description
        return example_definition.description unless example_definition.use_generated_description?
        return Spec::Matchers.generated_description if Spec::Matchers.generated_description
        return "NO NAME (Because of Error raised in matcher)" if failed?
        "NO NAME (Because there were no expectations)"
      end

      def setup_mocks
        if example.respond_to?(:setup_mocks_for_rspec)
          example.setup_mocks_for_rspec
        end
      end

      def verify_mocks
        if example.respond_to?(:verify_mocks_for_rspec)
          example.verify_mocks_for_rspec
        end
      end

      def teardown_mocks
        if example.respond_to?(:teardown_mocks_for_rspec)
          example.teardown_mocks_for_rspec
        end
      end
    end
  end
end
