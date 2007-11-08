module Spec
  module DSL
    class Example < ::Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)

      class << self
        include Behaviour
        def inherited(klass)
          super
          unless klass.name.to_s == ""
            klass.describe(klass.name)
            klass.register
          end
        end

        def suite
          description = description ? description.description : "RSpec Description Suite"
          suite = ExampleSuite.new(description, self)
          ordered_example_definitions.each do |example_definition|
            suite << new(example_definition)
          end
          
          add_examples_from_methods(suite)
          
          suite
        end
        
        # Sets the #number on each ExampleDefinition and returns the next number
        def set_sequence_numbers(number) #:nodoc:
          ordered_example_definitions.each do |example_definition|
            example_definition.number = number
            number += 1
          end
          number
        end

        def register
          rspec_options.add_behaviour self
        end

        def run_before_each(example)
          execute_in_class_hierarchy(false) do |behaviour_class|
            example.eval_each_fail_fast(behaviour_class.before_each_parts)
          end
        end
        
        def run_before_all(example)
          execute_in_class_hierarchy(false) do |behaviour_class|
            example.eval_each_fail_fast(behaviour_class.before_all_parts)
          end
        end

        def run_after_all(example)
          execute_in_class_hierarchy(true) do |behaviour_class|
            example.eval_each_fail_slow(behaviour_class.after_all_parts)
          end
        end
        
        def run_after_each(example)
          execute_in_class_hierarchy(true) do |behaviour_class|
            example.eval_each_fail_slow(behaviour_class.after_each_parts)
          end
        end

      private

        def execute_in_class_hierarchy(superclass_first)
          classes = []
          current_class = self
          while current_class.is_a?(Behaviour)
            superclass_first ? classes << current_class : classes.unshift(current_class)
            current_class = current_class.superclass
          end

          classes.each do |behaviour_class|
            yield behaviour_class
          end
        end

        def add_examples_from_methods(suite)
          instance_methods.each do |method_name|
            if (is_test?(method_name) || is_spec?(method_name)) && (
              instance_method(method_name).arity == 0 ||
              instance_method(method_name).arity == -1
            )
              example_definition = ExampleDefinition.new(method_name) do
                __send__ method_name
              end
              suite << new(example_definition)
            end
          end
        end

        def is_test?(method_name)
          method_name =~ /^test./
        end
        
        def is_spec?(method_name)
          !(method_name =~ /^should(_not)?$/) && method_name =~ /^should/
        end

        def ordered_example_definitions
          rspec_options.reverse ? example_definitions.reverse : example_definitions
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

        def define_predicate_matchers(definitions) # :nodoc:
          definitions.each_pair do |matcher_method, method_on_object|
            define_method matcher_method do |*args|
              eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
            end
          end
        end
      end

      include ::Spec::Matchers
      include ::Spec::DSL::Pending

      attr_reader :rspec_definition
      alias_method :definition, :rspec_definition

      def initialize(definition) #:nodoc:
        @rspec_definition = definition
        @behaviour_class = self.class
        
        @_result = ::Test::Unit::TestResult.new

        predicate_matchers = @behaviour_class.predicate_matchers

        (class << self; self; end).class_eval do
          plugin_mock_framework
          define_predicate_matchers predicate_matchers
          define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
        end
      end

      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@rspec_definition, :@_result])
      end

      def run_before_all
        @behaviour_class.run_before_all(self)
      end

      def run_before_each
        @behaviour_class.run_before_each(self)
      end

      def run_after_each
        @behaviour_class.run_after_each(self)
      end

      def run_after_all
        @behaviour_class.run_after_all(self)
      end

      def run_example
        instance_eval(&rspec_definition.example_block)
      end

      def eval_each_fail_fast(procs) #:nodoc:
        procs.each do |proc|
          instance_eval(&proc)
        end
      end

      def eval_each_fail_slow(procs) #:nodoc:
        first_exception = nil
        procs.each do |proc|
          begin
            instance_eval(&proc)
          rescue Exception => e
            first_exception ||= e
          end
        end
        raise first_exception if first_exception
      end

    end
  end
  
  ExampleGroup = Spec::DSL::Example
end
