module Spec
  module Runner
    class Configuration
      attr_writer :use_transactional_fixtures, :use_instantiated_fixtures, :fixture_path, :global_fixtures
      
      def use_transactional_fixtures
        @use_transactional_fixtures ||= true
      end
      
      def use_instantiated_fixtures
        @use_instantiated_fixtures ||= false
      end
      
      def fixture_path
        @fixture_path ||= RAILS_ROOT + '/spec/fixtures'
      end
      
      def global_fixtures
        @global_fixtures ||= []
      end
      
      def configure(behaviour)
        behaviour.use_transactional_fixtures = use_transactional_fixtures
        behaviour.use_instantiated_fixtures = use_instantiated_fixtures
        behaviour.fixture_path = fixture_path
        behaviour.global_fixtures = global_fixtures
      end
    end
  end
end