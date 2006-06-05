require File.dirname(__FILE__) + '/../vendor/plugins/rspec_on_rails/lib/rspec_on_rails'

module Spec
  module Runner
    class Context
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures  = false
      self.fixture_path = RAILS_ROOT + '/spec/fixtures'
    end
  end
end
