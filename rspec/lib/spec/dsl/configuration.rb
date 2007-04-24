module Spec
  module DSL
    class Configuration
      
      def mock_with(mock_framework)
        @mock_framework = Symbol === mock_framework ? mock_framework_path(mock_framework.to_s) : mock_framework
      end
      
      def mock_framework
        @mock_framework ||= mock_framework_path("rspec")
      end
      
    private
    
      def mock_framework_path(framework_name)
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "plugins", "mock_frameworks", framework_name))
      end
      
    end
  end
end