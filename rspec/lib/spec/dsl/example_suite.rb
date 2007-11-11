module Spec
  module DSL
    class ExampleSuite
      extend Forwardable
      attr_reader :examples, :example_group, :name
      alias :tests :examples
      
      private :example_group

      def initialize(name, example_group)
        @name = name
        @example_group = example_group
        @examples = []
      end

      def run
        retain_specified_examples
        return true if examples.empty?

        reporter.add_example_group(description)
        success = run_before_all
        if success
          example = nil
          examples.each do |example|
            example.copy_instance_variables_from(@before_and_after_all_example)

            runner = ExampleRunner.new(rspec_options, example)
            unless runner.run
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
        examples.length
      end

      def empty?
        size == 0
      end

      def delete(example)
        @examples.delete example
      end

      protected
      def retain_specified_examples
        return unless specified_examples
        return if specified_examples.empty?
        return if specified_examples.index(description.to_s)
        examples.reject! do |example|
          matcher = ExampleMatcher.new(description.to_s, example.description)
          !matcher.matches?(specified_examples)
        end
      end

      def run_before_all
        errors = []
        unless dry_run
          begin
            @before_and_after_all_example = example_group.new(nil)
            @before_and_after_all_example.run_before_all
          rescue Exception => e
            errors << e
            location = "before(:all)"
            # The easiest is to report this as an example failure. We don't have an Example
            # at this point, so we'll just create a placeholder.
            reporter.example_finished(create_example(location), e, location)
            return false
          end
        end
        return true
      end

      def run_after_all
        unless dry_run
          begin
            @before_and_after_all_example ||= example_group.new(nil)
            @before_and_after_all_example.run_after_all
          rescue Exception => e
            location = "after(:all)"
            reporter.example_finished(create_example(location), e, location)
            return false
          end
        end
        return true
      end

      def create_example(location)
        example_group.create_example location
      end

      def description
        example_group.description
      end

      def specified_examples
        rspec_options.examples
      end

      def reporter
        rspec_options.reporter
      end

      def dry_run
        rspec_options.dry_run
      end
    end
  end
end