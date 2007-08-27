require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Runner
      describe ScenarioCollector do
        it 'should construct scenarios with the supplied story' do
          # given
          story = stub_everything('story')
          scenario_collector = ScenarioCollector.new(story)
          
          # when
          scenario_collector.Scenario 'scenario1' do end
          scenario_collector.Scenario 'scenario2' do end
          scenarios = scenario_collector.scenarios
          
          # then
          ensure_that scenarios.size, is(2)
          ensure_that scenarios[0].name, is('scenario1')
          ensure_that scenarios[0].story, is(story)
          ensure_that scenarios[1].name, is('scenario2')
          ensure_that scenarios[1].story, is(story)
        end
      end
    end
  end
end
