module Spec
  module Story
    module Runner
      class ScenarioRunner
        def initialize
          @listeners = []
        end
        
        def run(scenario, world)
          begin
            raise Spec::DSL::ExamplePendingError unless scenario.body
            @listeners.each { |l| l.scenario_started(scenario.story.title, scenario.name) }
            run_story_ignoring_scenarios(scenario.story, world)
            world.instance_eval(&scenario.body)
            @listeners.each { |l| l.scenario_succeeded(scenario.story.title, scenario.name) }
          rescue Spec::DSL::ExamplePendingError => e
            @listeners.each { |l| l.scenario_pending(scenario.story.title, scenario.name, e.message) }
          rescue StandardError => e
            @listeners.each { |l| l.scenario_failed(scenario.story.title, scenario.name, e) }
          end
        end
        
        def add_listener(listener)
          @listeners << listener
        end
        
        private
        
        def run_story_ignoring_scenarios(story, world)
          class << world
            def Scenario(name, &block)
              # do nothing
            end
          end
          story.run_in(world)
          class << world
            remove_method(:Scenario)
          end
        end
      end
    end
  end
end
