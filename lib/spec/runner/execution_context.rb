module Spec
  module Runner
    class ExecutionContext
      def initialize(spec)
        @spec = spec
      end
      
      def mock(name, options={})
        mock = Api::Mock.new(name, options)
        @spec.add_mock(mock)
        mock
      end
      
      def duck_type(*args)
        return Api::DuckTypeArgConstraint.new(*args)
      end
      
      def violated(message="")
        raise Spec::Api::ExpectationNotMetError.new(message)
      end
    end
  end
end