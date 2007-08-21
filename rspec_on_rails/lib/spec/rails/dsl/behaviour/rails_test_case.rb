module Spec
  module Rails
    module DSL
      class RailsTestCase < Test::Unit::TestCase
        cattr_accessor :fixture_path, :use_transactional_fixtures, :use_instantiated_fixtures, :global_fixtures
        remove_method :default_test if respond_to?(:default_test)

        def initialize()
        end

        def add_assertion #:nodoc:
          # no-op
        end
      end
    end
  end
end
