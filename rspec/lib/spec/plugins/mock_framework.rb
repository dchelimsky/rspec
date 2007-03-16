mock_framework = Object.const_defined?("Mocha") ? :mocha : :rspec
require File.expand_path(File.join(File.dirname(__FILE__), "mock_frameworks", mock_framework.to_s))
