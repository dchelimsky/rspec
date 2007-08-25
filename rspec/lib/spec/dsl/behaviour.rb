module Spec
  module DSL
    class Behaviour < Module
      extend Forwardable
      extend BehaviourCallbacks
      include BehaviourMethods
      public :include

      def run(reporter, dry_run=false, reverse=false, timeout=nil)
        return if example_definitions.empty?
        reporter.add_behaviour(description)
        before_all_errors = run_before_all(reporter, dry_run)

        if before_all_errors.empty?
          example = nil
          ordered_example_definitions(reverse).each do |example_definition|
            example = create_example(example_definition)
            example.copy_instance_variables_from(@before_and_after_all_example)

            unless example_definition.pending?
              befores = before_each_proc(behaviour_type) {|e| raise e}
              afters = after_each_proc(behaviour_type)
            end
            example_definition.run(reporter, befores, afters, dry_run, example, timeout)
          end
          @before_and_after_all_example.copy_instance_variables_from(example)
        end

        run_after_all(reporter, dry_run)
      end

      def run_before_all(reporter, dry_run)
        errors = []
        unless dry_run
          begin
            @before_and_after_all_example = create_example(nil)
            @before_and_after_all_example.instance_eval(&before_all_proc(behaviour_type))
          rescue Exception => e
            errors << e
            location = "before(:all)"
            # The easiest is to report this as an example failure. We don't have an ExampleDefinition
            # at this point, so we'll just create a placeholder.
            reporter.example_finished(create_example_definition(location), e, location) if reporter
          end
        end
        errors
      end

      def run_after_all(reporter, dry_run)
        unless dry_run
          begin
            @before_and_after_all_example ||= create_example(nil)
            @before_and_after_all_example.instance_eval(&after_all_proc(behaviour_type))
          rescue Exception => e
            location = "after(:all)"
            reporter.example_finished(create_example_definition(location), e, location) if reporter
          end
        end
      end

      def retain_examples_matching!(specified_examples)
        return if specified_examples.index(description.to_s)
        matcher = ExampleMatcher.new(description.to_s)
        example_definitions.reject! do |example|
          !example.matches?(matcher, specified_examples)
        end
      end

      # Sets the #number on each ExampleDefinition and returns the next number
      def set_sequence_numbers(number, reverse) #:nodoc:
        ordered_example_definitions(reverse).each do |example|
          example.number = number
          number += 1
        end
        number
      end

      def shared?
        false
      end

      protected

      def ordered_example_definitions(reverse)
        reverse ? example_definitions.reverse : example_definitions
      end

      def before_each_proc(behaviour_type, &error_handler)
        parts = []
        parts.push(*Behaviour.before_each_parts(nil))
        parts.push(*Behaviour.before_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*before_each_parts(nil))
        parts.push(*before_each_parts(behaviour_type)) unless behaviour_type.nil?
        CompositeProcBuilder.new(parts).proc(&error_handler)
      end

      def before_all_proc(behaviour_type, &error_handler)
        parts = []
        parts.push(*Behaviour.before_all_parts(nil))
        parts.push(*Behaviour.before_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*before_all_parts(nil))
        parts.push(*before_all_parts(behaviour_type)) unless behaviour_type.nil?
        CompositeProcBuilder.new(parts).proc(&error_handler)
      end

      def after_all_proc(behaviour_type)
        parts = []
        parts.push(*after_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*after_all_parts(nil))
        parts.push(*Behaviour.after_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*Behaviour.after_all_parts(nil))
        CompositeProcBuilder.new(parts).proc
      end

      def after_each_proc(behaviour_type)
        parts = []
        parts.push(*after_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*after_each_parts(nil))
        parts.push(*Behaviour.after_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*Behaviour.after_each_parts(nil))
        CompositeProcBuilder.new(parts).proc
      end

      def create_example(example_definition)
        example_class.new(self, example_definition)
      end

      def example_class
        Example
      end
    end
  end
end
