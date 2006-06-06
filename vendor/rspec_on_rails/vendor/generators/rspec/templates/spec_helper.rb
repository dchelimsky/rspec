<% if `svn info` =~ /var\/svn\/rspec/n %>$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../vendor/generators/rspec/lib')<% end %>
require 'rspec_on_rails'

module Spec
  module Runner
    class Context
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures  = false
      self.fixture_path = RAILS_ROOT + '/spec/fixtures'
    end
  end
end
