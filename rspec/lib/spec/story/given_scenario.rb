module Spec
  module Story
    class GivenScenario
      def initialize name
        @name = name
      end
      
      def perform(instance)
        scenario = Runner::StoryRunner.scenario_from_current_story @name
        Runner::ScenarioRunner.new.run(scenario, instance)
      end
    end
  end
end
