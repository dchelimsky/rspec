module Spec
  module Runner
    class ExecutionContext
      module InstanceMethods
        def initialize(spec)
          @spec = spec
        end

        def mock(name, options={})
          mock = Spec::Mocks::Mock.new(name, options)
          @spec.add_mock(mock)
          mock
        end

        def duck_type(*args)
          return Spec::Mocks::DuckTypeArgConstraint.new(*args)
        end

        def violated(message="")
          raise Spec::Expectations::ExpectationNotMetError.new(message)
        end

        private
        def stub_space
          @spec.stub_space
        end
      end
      include InstanceMethods
    end
  end
end