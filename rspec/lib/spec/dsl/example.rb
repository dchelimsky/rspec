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
          description = description ? description.description : "Rspec Description Suite"
          suite = ExampleSuite.new(description, self)
          ordered_example_definitions.each do |example_definition|
            suite << new(example_definition)
          end
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
          suite
        end
        
        def is_test?(method_name)
          method_name =~ /^test./
        end
        
        def is_spec?(method_name)
          !(method_name =~ /^should(_not)?$/) && method_name =~ /^should/
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

        def behaviour_chain
          behaviours = []
          current_class = self
          while current_class.is_a?(Behaviour)
            behaviours << current_class
            current_class = current_class.superclass
          end
          behaviours
        end

        protected

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
        @_result = ::Test::Unit::TestResult.new

        predicate_matchers = self.class.predicate_matchers
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

      def before_each
        behaviours = self.class.behaviour_chain
        behaviours.reverse!
        behaviours.each do |behaviour|
          run_before_parts behaviour.before_each_parts
        end
      end

      def before_all
        behaviours = self.class.behaviour_chain
        behaviours.reverse!
        behaviours.each do |behaviour|
          run_before_parts behaviour.before_all_parts
        end
      end

      def after_all
        exception = nil
        behaviours = self.class.behaviour_chain
        behaviours.each do |behaviour|
          exception = run_after_parts(exception, behaviour.after_all_parts)
        end
        raise exception if exception
      end

      def after_each
        exception = nil
        behaviours = self.class.behaviour_chain
        behaviours.each do |behaviour|
          exception = run_after_parts(exception, behaviour.after_each_parts)
        end
        raise exception if exception
      end

      def run_example
        self.instance_eval(&rspec_definition.example_block)
      end

      protected
      def run_before_parts(parts)
        parts.each do |part|
          self.instance_eval(&part)
        end
      end

      def run_after_parts(original_exception, parts)
        new_exception = nil
        parts.each do |part|
          begin
            self.instance_eval(&part)
          rescue Exception => e
            new_exception ||= e
          end
        end
        return original_exception || new_exception
      end
    end
  end
  
  ExampleGroup = Spec::DSL::Example
end
