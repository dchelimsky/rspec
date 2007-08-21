ActionView::Base.cache_template_extensions = false

module Spec
  module Rails
    module DSL
      class RailsBehaviour < Spec::DSL::Behaviour
        attr_reader :test_case_class

        def configure
          self.use_transactional_fixtures = Spec::Runner.configuration.use_transactional_fixtures
          self.use_instantiated_fixtures = Spec::Runner.configuration.use_instantiated_fixtures
          self.fixture_path = Spec::Runner.configuration.fixture_path
          self.global_fixtures = Spec::Runner.configuration.global_fixtures
          self.fixtures(self.global_fixtures) if self.global_fixtures
        end

        def_delegators(
          :@test_case_class,
          :use_transactional_fixtures,
          :use_transactional_fixtures=,
          :use_instantiated_fixtures,
          :use_instantiated_fixtures=,
          :fixture_path,
          :fixture_path=,
          :global_path,
          :global_path=,
          :fixtures,
          :global_fixtures,
          :global_fixtures=
        )

        def before_eval
          super
          @test_case_class = Class.new(Spec::Rails::DSL::RailsTestCase)
        end

        def example_space_superclass
          RailsExampleSpace
        end

        # You MUST provide a controller_name within the context of
        # your controller specs:
        #
        #   describe "ThingController" do
        #     controller_name :thing
        #     ...
        def controller_name(name)
          @controller_class_name = "#{name}_controller".camelize
        end
        attr_accessor :controller_class_name # :nodoc:
      end
    end
  end
end
