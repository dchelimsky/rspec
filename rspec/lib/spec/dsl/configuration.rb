module Spec
  module DSL
    class Configuration
      
      def mock_with(mock_framework)
        case mock_framework
        when :rspec
          @mock_framework = relative_path(["..", "mocks", "plugin"])
        when Symbol
          @mock_framework = relative_path(["..", "..", "plugins", "mock_frameworks", mock_framework.to_s])
        else
          @mock_framework = mock_framework
        end
      end
      
      def relative_path(*path_elements)
        File.expand_path(File.join(File.dirname(__FILE__), *path_elements))
      end
      
      def mock_framework
        @mock_framework ||= File.expand_path(File.join(File.dirname(__FILE__), "..", "mocks", "plugin"))
      end
      
    end
  end
end