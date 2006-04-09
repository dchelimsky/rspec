module Spec
  module Runner
    class ExecutionContext
      def initialize(spec)
        @spec = spec
      end
      
      def mock(name)
        mock = Api::Mock.new(name)
        @spec.add_mock(mock)
        mock
      end
      
      def violated(message="")
        raise Spec::Api::ExpectationNotMetError.new(message)
      end
    end
  end
end