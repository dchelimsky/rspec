ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rspec_on_rails'

module Test
  module Unit
    class TestCase
      self.fixture_path = RAILS_ROOT + '/spec/fixtures'
    end
  end
end
