require 'spec/example/configuration'

module Spec
  module Example
    class Configuration
      # All of this is ActiveRecord related and makes no sense if it's not used by the app
      if defined?(ActiveRecord::Base)
        def initialize
          super
          Test::Unit::TestCase.fixture_path = RAILS_ROOT + '/spec/fixtures'
        end

        def use_transactional_fixtures
          Test::Unit::TestCase.use_transactional_fixtures
        end
        def use_transactional_fixtures=(value)
          Test::Unit::TestCase.use_transactional_fixtures = value
        end
      
        def use_instantiated_fixtures
          Test::Unit::TestCase.use_instantiated_fixtures
        end
        def use_instantiated_fixtures=(value)
          Test::Unit::TestCase.use_instantiated_fixtures = value
        end
      
        def fixture_path
          Test::Unit::TestCase.fixture_path
        end
        def fixture_path=(path)
          Test::Unit::TestCase.fixture_path = path
        end
      
        def global_fixtures
          ::Test::Unit::TestCase.fixture_table_names
        end
        def global_fixtures=(fixtures)
          ::Test::Unit::TestCase.fixtures(*fixtures)
        end
      end
    end
  end
end
