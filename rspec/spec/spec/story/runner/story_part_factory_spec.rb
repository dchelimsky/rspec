require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Runner
      
      describe StoryPartFactory do
        before(:each) do
          $story_part_factory_spec_instance = nil
          @step_matchers = StepMatchers.new
          @step_matchers.create_matcher(:given, "given") { $story_part_factory_spec_instance = "given matched" }
          @step_matchers.create_matcher(:when, "when") { $story_part_factory_spec_instance = "when matched" }
          @step_matchers.create_matcher(:then, "then") { $story_part_factory_spec_instance = "then matched" }
          
          @factory = StoryPartFactory.new @step_matchers
          @scenario_runner = ScenarioRunner.new
          @runner = StoryRunner.new @scenario_runner
        end
        
        def run_stories
          @factory.stories.each { |story| @runner.instance_eval(&story) }
          @runner.run_stories
        end

        it "should have no stories" do
          @factory.stories.should be_empty
        end
        
        it "should create two stories" do
          @factory.create_story "story title", "story narrative"
          @factory.create_story "story title 2", "story narrative 2"
          run_stories
          
          @runner.should have(2).stories
          @runner.stories.first.title.should == "story title"
          @runner.stories.first.narrative.should == "story narrative"
          @runner.stories.last.title.should == "story title 2"
          @runner.stories.last.narrative.should == "story narrative 2"
        end
        
        it "should create a scenario" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario name"
          run_stories
          
          @runner.should have(1).scenarios
          @runner.scenarios.first.name.should == "scenario name"
          @runner.scenarios.first.story.should == @runner.stories.first
        end
        
        it "should create a given step if one matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_given "given"
          run_stories
          
          $story_part_factory_spec_instance.should == "given matched"
        end
        
        it "should create a pending step if no given step matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_given "no match"
          mock_listener = stub_everything("listener")
          mock_listener.should_receive(:scenario_pending).with("title", "scenario", "Unimplemented step: no match")
          @scenario_runner.add_listener mock_listener
          run_stories
        end
        
        it "should create a when step if one matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_when "when"
          run_stories
          
          $story_part_factory_spec_instance.should == "when matched"
        end
        
        it "should create a pending step if no when step matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_when "no match"
          mock_listener = stub_everything("listener")
          mock_listener.should_receive(:scenario_pending).with("title", "scenario", "Unimplemented step: no match")
          @scenario_runner.add_listener mock_listener
          run_stories
        end
        
        it "should create a then step if one matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_then "then"
          run_stories
          
          $story_part_factory_spec_instance.should == "then matched"
        end
        
        it "should create a pending step if no 'then' step matches" do
          @factory.create_story "title", "narrative"
          @factory.create_scenario "scenario"
          @factory.create_then "no match"
          mock_listener = stub_everything("listener")
          mock_listener.should_receive(:scenario_pending).with("title", "scenario", "Unimplemented step: no match")
          @scenario_runner.add_listener mock_listener
          run_stories
        end
        
      end
      
    end
  end
end