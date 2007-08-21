module Spec
  module DSL
    class ExampleSpace
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

        def include_example_modules(eval_module, behaviour_type)
          include eval_module
          Spec::Runner.configuration.modules_for(behaviour_type).each do |mod|
            include mod
          end
        end
      end
      include ::Spec::Matchers

      attr_reader :rspec_behaviour, :rspec_example

      def initialize(behaviour, example) #:nodoc:
        @rspec_behaviour = behaviour
        @rspec_example = example
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
