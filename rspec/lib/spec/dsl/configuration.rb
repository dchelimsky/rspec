module Spec
  module DSL
    class Configuration
      def mock_with(mock_framework)
        @mock_framework = mock_framework
      end
      def mock_framework
        @mock_framework ||= :rspec
      end
      
      def configure(behaviour)
        behaviour.mock_with(mock_framework)
      end
    end
  end
end