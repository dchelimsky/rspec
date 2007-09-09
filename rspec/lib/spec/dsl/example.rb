module Spec
  module DSL
    class Example < ::Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)
      class << self
        extend ExampleCallbacks
        include ExampleApi
        public :include
        attr_accessor :rspec_options

        def suite
          return ExampleSuite.new("Rspec Description Suite", self) unless description
          suite = ExampleSuite.new(description.description, self)
          suite
        end

        def run
          retain_specified_examples
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
              run_proxy = ExampleRunProxy.new(rspec_options, example)
              run_proxy.run(reporter, befores, afters, timeout)
            end
            @before_and_after_all_example.copy_instance_variables_from(example)
          end

          run_after_all(reporter, dry_run)
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

        def retain_specified_examples
          return if specified_examples.empty?
          return if specified_examples.index(description.to_s)
          matcher = ExampleMatcher.new(description.to_s)
          example_definitions.reject! do |example|
            !example.matches?(matcher, specified_examples)
          end
        end

        def reporter
          rspec_options.reporter
        end

        def dry_run
          rspec_options.dry_run
        end

        def reverse
          rspec_options.reverse
        end

        def timeout
          rspec_options.timeout
        end

        def specified_examples
          rspec_options.examples
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
              reporter.example_finished(create_example_definition(location), e, location)
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
              reporter.example_finished(create_example_definition(location), e, location)
            end
          end
        end

        def ordered_example_definitions(reverse)
          reverse ? example_definitions.reverse : example_definitions
        end

        def before_each_proc(behaviour_type, &error_handler)
          parts = []
          parts.push(*Example.before_each_parts(nil))
          parts.push(*Example.before_each_parts(behaviour_type)) if behaviour_type
          parts.push(*before_each_parts(nil))
          parts.push(*before_each_parts(behaviour_type)) if behaviour_type
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def before_all_proc(behaviour_type, &error_handler)
          parts = []
          parts.push(*Example.before_all_parts(nil))
          parts.push(*Example.before_all_parts(behaviour_type)) if behaviour_type
          parts.push(*before_all_parts(nil))
          parts.push(*before_all_parts(behaviour_type)) if behaviour_type
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def after_all_proc(behaviour_type)
          parts = []
          parts.push(*after_all_parts(behaviour_type)) if behaviour_type
          parts.push(*after_all_parts(nil))
          parts.push(*Example.after_all_parts(behaviour_type)) if behaviour_type
          parts.push(*Example.after_all_parts(nil))
          CompositeProcBuilder.new(parts).proc
        end

        def after_each_proc(behaviour_type)
          parts = []
          parts.push(*after_each_parts(behaviour_type)) if behaviour_type
          parts.push(*after_each_parts(nil))
          parts.push(*Example.after_each_parts(behaviour_type)) if behaviour_type
          parts.push(*Example.after_each_parts(nil))
          CompositeProcBuilder.new(parts).proc
        end

        def create_example(example_definition)
          new example_definition
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

        def include_example_modules(behaviour_type)
          Spec::Runner.configuration.modules_for(behaviour_type).each do |mod|
            include mod
          end
        end

        def define_predicate_matchers(definitions) # :nodoc:
          definitions.each_pair do |matcher_method, method_on_object|
            define_method matcher_method do |*args|
              eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
            end
          end
        end
      end
      include ::Spec::Matchers

      attr_reader :rspec_behaviour, :rspec_definition
      alias_method :behaviour, :rspec_behaviour
      alias_method :definition, :rspec_definition

      def initialize(definition) #:nodoc:
        @rspec_behaviour = self.class
        @rspec_definition = definition
        @_result = Test::Unit::TestResult.new
        
        behaviour_type = @rspec_behaviour.behaviour_type
        predicate_matchers = @rspec_behaviour.predicate_matchers
        (class << self; self; end).class_eval do
          plugin_mock_framework
          include_example_modules behaviour_type
          define_predicate_matchers predicate_matchers
          define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
        end
      end

      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      def inspect
        "[RSpec example]"
      end

      def pending(message)
        if block_given?
          begin
            yield
          rescue Exception => e
            raise Spec::DSL::ExamplePendingError.new(message)
          end
          raise Spec::DSL::PendingFixedError.new("Expected pending '#{message}' to fail. No Error was raised.")
        else
          raise Spec::DSL::ExamplePendingError.new(message)
        end
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@rspec_definition, :@rspec_behaviour, :@_result])
      end
    end
  end
end
