require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Runner
      describe StoryRunner do
        it 'should collect all the stories' do
          # given
          story_runner = StoryRunner.new(stub('scenario_runner'))
          
          # when
          story_runner.Story 'title1', 'narrative1' do end
          story_runner.Story 'title2', 'narrative2' do end
          stories = story_runner.stories
          
          # then
          ensure_that stories.size, is(2)
          ensure_that stories[0].title, is('title1')
          ensure_that stories[0].narrative, is('narrative1')
          ensure_that stories[1].title, is('title2')
          ensure_that stories[1].narrative, is('narrative2')
        end
        
        it 'should gather all the scenarios in the stories' do
          # given
          story_runner = StoryRunner.new(stub('scenario_runner'))
          
          # when
          story_runner.Story "story1", "narrative1" do
            Scenario "scenario1" do end
            Scenario "scenario2" do end
          end
          story_runner.Story "story2", "narrative2" do
            Scenario "scenario3" do end
          end
          scenarios = story_runner.scenarios
          
          # then
          ensure_that scenarios.size, is(3)
          ensure_that scenarios[0].name, is('scenario1')
          ensure_that scenarios[1].name, is('scenario2')
          ensure_that scenarios[2].name, is('scenario3')
        end
        
        # captures worlds passed into a ScenarioRunner
        class ScenarioWorldCatcher
          attr_accessor :worlds
          def run(scenario, world)
           (@worlds ||= [])  << world
          end
        end
        
        it 'should run each scenario in a separate object' do
          # given
          scenario_world_catcher = ScenarioWorldCatcher.new
          story_runner = StoryRunner.new(scenario_world_catcher)
          story_runner.Story 'story', 'narrative' do
            Scenario 'scenario1' do end
            Scenario 'scenario2' do end
          end
          
          # when
          story_runner.run_stories
          
          # then
          worlds = scenario_world_catcher.worlds
          ensure_that worlds.size, is(2)
          worlds[0].should_not == worlds[1]
        end
        
        it 'should use the provided world creator to create worlds' do
          # given
          stub_scenario_runner = stub_everything
          mock_world_creator = mock('world creator')
          story_runner = StoryRunner.new(stub_scenario_runner, mock_world_creator)
          story_runner.Story 'story', 'narrative' do
            Scenario 'scenario1' do end
            Scenario 'scenario2' do end
          end
          
          # expect
          mock_world_creator.should_receive(:create).twice
          
          # when
          story_runner.run_stories
          
          # then
          # TODO verify_all
        end
        
        it 'should notify listeners of the scenario count when the run starts' do
          # given
          story_runner = StoryRunner.new(stub_everything)
          mock_listener1 = stub_everything('listener1')
          mock_listener2 = stub_everything('listener2')
          story_runner.add_listener(mock_listener1)
          story_runner.add_listener(mock_listener2)
          
          story_runner.Story 'story1', 'narrative1' do
            Scenario 'scenario1' do end
          end
          story_runner.Story 'story2', 'narrative2' do
            Scenario 'scenario2' do end
            Scenario 'scenario3' do end
          end
          
          # expect
          mock_listener1.should_receive(:run_started).with(3)
          mock_listener2.should_receive(:run_started).with(3)
          
          # when
          story_runner.run_stories
          
          # then
          # TODO verify_all
        end
        
        it 'should notify listeners when a story starts' do
          # given
          story_runner = StoryRunner.new(stub_everything)
          mock_listener1 = stub_everything('listener1')
          mock_listener2 = stub_everything('listener2')
          story_runner.add_listener(mock_listener1)
          story_runner.add_listener(mock_listener2)
          
          story_runner.Story 'story1', 'narrative1' do
            Scenario 'scenario1' do end
          end
          story_runner.Story 'story2', 'narrative2' do
            Scenario 'scenario2' do end
            Scenario 'scenario3' do end
          end
          
          # expect
          mock_listener1.should_receive(:story_started).with('story1', 'narrative1')
          mock_listener1.should_receive(:story_ended).with('story1', 'narrative1')
          mock_listener2.should_receive(:story_started).with('story2', 'narrative2')
          mock_listener2.should_receive(:story_ended).with('story2', 'narrative2')
          
          # when
          story_runner.run_stories
          
          # then
          # TODO verify_all
        end
        
        it 'should notify listeners when the run ends' do
          # given
          story_runner = StoryRunner.new(stub_everything)
          mock_listener1 = stub_everything('listener1')
          mock_listener2 = stub_everything('listener2')
          story_runner.add_listener mock_listener1
          story_runner.add_listener mock_listener2
          story_runner.Story 'story1', 'narrative1' do
            Scenario 'scenario1' do end
          end
          
          # expect
          mock_listener1.should_receive(:run_ended)
          mock_listener2.should_receive(:run_ended)
          
          # when
          story_runner.run_stories
          
          # then
          # TODO verify_all
        end
        
        it 'should run a story in an instance of a specified class' do
          # given
          scenario_world_catcher = ScenarioWorldCatcher.new
          story_runner = StoryRunner.new(scenario_world_catcher)
          story_runner.Story 'title', 'narrative', :type => String do
            Scenario 'scenario' do end
          end
          
          # when
          story_runner.run_stories
          
          # then
          scenario_world_catcher.worlds[0].should be_kind_of(String)
          scenario_world_catcher.worlds[0].should be_kind_of(World)
        end
        
        it 'should pass initialization params through to the constructed instance' do
          # given
          scenario_world_catcher = ScenarioWorldCatcher.new
          story_runner = StoryRunner.new(scenario_world_catcher)
          story_runner.Story 'title', 'narrative', :type => Array, :args => [3]  do
            Scenario 'scenario' do end
          end
          
          # when
          story_runner.run_stories
          
          # then
          scenario_world_catcher.worlds[0].should be_kind_of(Array)
          scenario_world_catcher.worlds[0].size.should == 3
        end
        
        it 'should find a scenario in the current story by name' do
          # given
          story_runner = StoryRunner.new(ScenarioRunner.new)
          $scenario = nil
          
          story_runner.Story 'title', 'narrative' do
            Scenario 'first scenario' do
            end
            Scenario 'second scenario' do
              $scenario = StoryRunner.scenario_from_current_story 'first scenario'
            end
          end
          
          # when
          story_runner.run_stories
          
          # then
          $scenario.name.should == 'first scenario'
        end
      end
    end
  end
end
