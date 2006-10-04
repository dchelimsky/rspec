ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rspec_on_rails'

module Test
  module Unit
    class TestCase
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures  = false
      self.fixture_path = RAILS_ROOT + '/spec/fixtures'

      # You can set up your global fixtures here, or you
      # can do it in individual contexts
      #fixtures :table_a, :table_b
    end
  end
end