module Spec
  module Example
    class ExampleRunner

      def initialize(options, example_group_instance)
        @options = options
        @example_group_instance = example_group_instance
        @errors = []
      end
      
      def run
        example = @example_group_instance._example
        reporter.example_started(example)
        if dry_run
          if @example_group_instance.use_generated_description?
            @example_group_instance.description = "NO NAME (Because of --dry-run)"
          end
          return reporter.example_finished(example, nil, @example_group_instance.description)
        end

        Timeout.timeout(timeout) do
          before_each_ok = before_example
          run_example if before_each_ok
          after_example
          @example_group_instance.description = description
          Spec::Matchers.clear_generated_description
        end

        reporter.example_finished(
          example,
          @errors.first,
          description
        )
        ok?
      end

      protected

      def ok?
        @errors.empty? || @errors.all? {|error| error.is_a?(Spec::Example::ExamplePendingError)}
      end

      def before_example
        @example_group_instance.run_before_each
        true
      rescue Exception => e
        @errors << e
        false
      end

      def run_example
        @example_group_instance.run
      rescue Exception => e
        @errors << e
      end

      def after_example
        @example_group_instance.run_after_each

        begin
          @example_group_instance.verify_mocks_for_rspec
        ensure
          @example_group_instance.teardown_mocks_for_rspec
        end
      rescue Exception => e
        @errors << e
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
        example = @example_group_instance._example
        return example.description unless @example_group_instance.use_generated_description?
        return Spec::Matchers.generated_description if Spec::Matchers.generated_description
        return ok? ? "NO NAME (Because there were no expectations)" : "NO NAME (Because of Error raised in matcher)"
      end

    end
  end
end
