ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'controller_mixin'
require 'rspec_on_rails'

class SpecTestCase < Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  self.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can set up your global fixtures here, or you
  # can do it in individual contexts
  #fixtures :table_a, :table_b

  def run(*args)
  end

  def setup
    super
  end

  def teardown
    super
  end

  def should_have_tag tag, *opts
    response.body.should_have_tag tag, *opts
  end

  def should_not_have_tag tag, *opts
    response.body.should_not_have_tag tag, *opts
  end
end

module Spec
  module Runner
    class Context
      def before_context_eval
        inherit SpecTestCase
      end
    end
  end
end

Test::Unit.run = true