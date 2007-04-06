mock_framework = Spec::Runner.configuration.mock_framework
require File.expand_path(File.join(File.dirname(__FILE__), "mock_frameworks", mock_framework.to_s))
