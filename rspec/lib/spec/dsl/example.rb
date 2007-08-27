module Spec
  module DSL
    class Example
      class << self
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

      def initialize(behaviour, definition) #:nodoc:
        (class << self; self; end).class_eval do
          plugin_mock_framework
          include behaviour
          include_example_modules behaviour.behaviour_type
          define_predicate_matchers(behaviour.predicate_matchers)
          define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
        end
        @rspec_behaviour = behaviour
        @rspec_definition = definition
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
    end
  end
end
