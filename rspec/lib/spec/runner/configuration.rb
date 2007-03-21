module Spec
  module Runner
    class Configuration
      def mock_with(mock_framework)
        @mock_framework = mock_framework
      end
      def mock_framework
        @mock_framework ||= :rspec
      end
    end
  end
end