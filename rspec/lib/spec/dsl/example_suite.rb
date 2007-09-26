module Spec
  module DSL
    class ExampleSuite < ::Test::Unit::TestSuite
      extend Forwardable
      attr_reader :examples, :behaviour
      alias_method :tests, :examples

      def initialize(name, behaviour)
        super name
        @behaviour = behaviour
        @examples = []
      end

      def run(result, &progress_block)
        return true if result.is_a?(::Test::Unit::TestResult)
        retain_specified_examples
        return true if examples.empty?

        reporter.add_behaviour(description)
        success = run_before_all
        if success
          example = nil
          examples.each do |example|
            example.copy_instance_variables_from(@before_and_after_all_example)

            run_proxy = ExampleRunner.new(rspec_options, example)
            unless run_proxy.run(&progress_block)
              success = false
            end
          end
          @before_and_after_all_example.copy_instance_variables_from(example)
        end

        unless run_after_all
          success = false
        end
        return success
      end

      def <<(example)
        examples << example
      end

      def size
        @behaviour.number_of_examples
      end

      protected
      def retain_specified_examples
        return unless specified_examples
        return if specified_examples.empty?
        return if specified_examples.index(description.to_s)
        examples.reject! do |example|
          matcher = ExampleMatcher.new(description.to_s, example.rspec_definition.description)
          !matcher.matches?(specified_examples)
        end
      end

      def run_before_all
        errors = []
        unless dry_run
          begin
            @before_and_after_all_example = behaviour.new(nil)
            @before_and_after_all_example.before_all
          rescue Exception => e
            errors << e
            location = "before(:all)"
            # The easiest is to report this as an example failure. We don't have an ExampleDefinition
            # at this point, so we'll just create a placeholder.
            reporter.example_finished(create_example_definition(location), e, location)
            return false
          end
        end
        return true
      end

      def run_after_all
        unless dry_run
          begin
            @before_and_after_all_example ||= behaviour.new(nil)
            @before_and_after_all_example.after_all
          rescue Exception => e
            location = "after(:all)"
            reporter.example_finished(create_example_definition(location), e, location)
            return false
          end
        end
        return true
      end

      def_delegator :behaviour, :create_example_definition
      def_delegator :behaviour, :description
      def_delegator :behaviour, :behaviour_type
      def_delegator :behaviour, :before_all_proc
      def_delegator :behaviour, :before_each_proc
      def_delegator :behaviour, :after_each_proc
      def_delegator :behaviour, :after_all_proc
      def_delegator :rspec_options, :examples, :specified_examples
      def_delegator :rspec_options, :reporter
      def_delegator :rspec_options, :dry_run
    end
  end
end