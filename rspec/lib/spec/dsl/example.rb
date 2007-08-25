module Spec
  module DSL
    class Example
      class << self
        attr_accessor :description

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
      end
      include ::Spec::Matchers

      attr_reader :rspec_behaviour, :rspec_example_definition
      alias_method :behaviour, :rspec_behaviour
      alias_method :example_definition, :rspec_example_definition

      def initialize(behaviour, example_definition) #:nodoc:
        (class << self; self; end).class_eval do
          plugin_mock_framework
          include behaviour
          include_example_modules behaviour.behaviour_type
        end
        @rspec_behaviour = behaviour
        @rspec_example_definition = example_definition
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
