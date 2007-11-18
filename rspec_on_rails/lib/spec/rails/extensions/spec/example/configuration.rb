require 'spec/example/configuration'

module Spec
  module Example
    class Configuration
      attr_writer :use_transactional_fixtures, :use_instantiated_fixtures, :global_fixtures

      def initialize
        super
        Test::Unit::TestCase.fixture_path = RAILS_ROOT + '/spec/fixtures'
      end
      
      def use_transactional_fixtures
        @use_transactional_fixtures.nil? ? @use_transactional_fixtures = true : @use_transactional_fixtures
      end
      
      def use_instantiated_fixtures
        @use_instantiated_fixtures ||= false
      end
      
      def fixture_path
        Test::Unit::TestCase.fixture_path
      end
      def fixture_path=(path)
        Test::Unit::TestCase.fixture_path = path
      end
      
      def global_fixtures
        @global_fixtures ||= []
      end
    end
  end
end
