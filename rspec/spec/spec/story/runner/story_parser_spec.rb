require File.dirname(__FILE__) + '/../story_helper'

module Spec
	module Story
		module Runner
		  
			describe StoryParser do
			  before(:each) do
			    @story_mediator = mock("story_mediator")
		    	@parser = StoryParser.new(@story_mediator)
			  end

			  it "should parse no lines" do
					@parser.parse([])
			  end
			  
			  it "should ignore text before the first Story: begins" do
			    @story_mediator.should_not_receive(:create_scenario)
			    @story_mediator.should_not_receive(:create_given)
			    @story_mediator.should_not_receive(:create_when)
			    @story_mediator.should_not_receive(:create_then)
			    @story_mediator.should_receive(:create_story).with("simple addition", "")
					@parser.parse(["Here is a bunch of text", "about a calculator and all the things", "that it will do", "Story: simple addition"])
		    end
			  
			  it "should create a story" do
			    @story_mediator.should_receive(:create_story).with("simple addition", "")
					@parser.parse(["Story: simple addition"])
			  end
			  
			  it "should create a story when line has leading spaces" do
			    @story_mediator.should_receive(:create_story).with("simple addition", "")
					@parser.parse(["    Story: simple addition"])
			  end
			  
			  it "should create a second story if no scenario" do
			    @story_mediator.should_receive(:create_story).with("simple addition", "")
			    @story_mediator.should_receive(:create_story).with("simple subtraction", "")
					@parser.parse(["Story: simple addition","Story: simple subtraction"])
			  end
			  
			  it "should add a one line narrative to the story" do
			    @story_mediator.should_receive(:create_story).with("simple addition","narrative")
					@parser.parse(["Story: simple addition","narrative"])
			  end
			  
			  it "should add a multi line narrative to the story" do
			    @story_mediator.should_receive(:create_story).with("simple addition","narrative line 1\nline 2\nline 3")
					@parser.parse(["Story: simple addition","narrative line 1", "line 2", "line 3"])
			  end
			  
			  it "should exclude blank lines from the narrative" do
			    @story_mediator.should_receive(:create_story).with("simple addition","narrative line 1\nline 2")
					@parser.parse(["Story: simple addition","narrative line 1", "", "line 2"])
			  end
			  
			  it "should exclude Scenario from the narrative" do
			    @story_mediator.should_receive(:create_story).with("simple addition","narrative line 1\nline 2")
			    @story_mediator.should_receive(:create_scenario)
					@parser.parse(["Story: simple addition","narrative line 1", "line 2", "Scenario: add one plus one"])
			  end
			  
			  it "should create a Scenario" do
			    @story_mediator.should_receive(:create_story)
			    @story_mediator.should_receive(:create_scenario).with("add one plus one")
					@parser.parse(["Story: simple addition","narrative line 1", "line 2", "Scenario: add one plus one"])
			  end
			  
			  it "should create a Given" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
			    @story_mediator.should_receive(:create_given).with("an addend of 1")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1"])
			  end
			  
			  it "should create a When after a Then" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
          @story_mediator.should_receive(:create_given)
			    @story_mediator.should_receive(:create_when).with("b")
			    @story_mediator.should_receive(:create_then).with("c")
			    @story_mediator.should_receive(:create_when).with("d")
			    @story_mediator.should_receive(:create_then).with("e")
					@parser.parse(["Story: foo","Scenario: bar","Given a","When b","Then c","When d","Then e"])
			  end
			  
			  it "should create a When for an And after a When" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
          @story_mediator.should_receive(:create_given).twice
			    @story_mediator.should_receive(:create_when).with("the addends are added")
			    @story_mediator.should_receive(:create_when).with("the corks are popped")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1", "And an addend of 1", "When the addends are added", "And the corks are popped"])
			  end
			  
			  it "should create a When for each of two Ands after a When" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
          @story_mediator.should_receive(:create_given).twice
			    @story_mediator.should_receive(:create_when).with("the addends are added")
			    @story_mediator.should_receive(:create_when).with("the corks are popped")
			    @story_mediator.should_receive(:create_when).with("the bottle is emptied")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1", "And an addend of 1", "When the addends are added", "And the corks are popped", "And the bottle is emptied"])
			  end
			  
			  it "should create a Then" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
          @story_mediator.should_receive(:create_given).twice
          @story_mediator.should_receive(:create_when)
			    @story_mediator.should_receive(:create_then).with("the sum should be 2")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1", "And an addend of 1", "When the addends are added", "Then the sum should be 2"])
			  end
			  
			  it "should create a Then for an And after a Then" do
			    @story_mediator.should_receive(:create_story)
          @story_mediator.should_receive(:create_scenario)
          @story_mediator.should_receive(:create_given).twice
          @story_mediator.should_receive(:create_when)
			    @story_mediator.should_receive(:create_then).with("the sum should be 2")
			    @story_mediator.should_receive(:create_then).with("the corks should be popped")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1", "And an addend of 1", "When the addends are added", "Then the sum should be 2", "And the corks should be popped"])
			  end
			  
			  it "should create a Then for each of two Ands after a Then" do
			    @story_mediator.should_receive(:create_story)
			    @story_mediator.should_receive(:create_scenario)
			    @story_mediator.should_receive(:create_given).twice
			    @story_mediator.should_receive(:create_when)
			    @story_mediator.should_receive(:create_then).with("the sum should be 2")
			    @story_mediator.should_receive(:create_then).with("the corks should be popped")
			    @story_mediator.should_receive(:create_then).with("the bottle should be emptied")
					@parser.parse(["Story: simple addition","Scenario: add one plus one", "Given an addend of 1", "And an addend of 1", "When the addends are added", "Then the sum should be 2", "And the corks should be popped", "And the bottle should be emptied"])
			  end
			  
			  it "should create a Scenario for a new Scenario after a Scenario" do
			    @story_mediator.should_receive(:create_story)
			    @story_mediator.should_receive(:create_scenario).with("first scenario")
			    @story_mediator.should_receive(:create_scenario).with("second scenario")
					@parser.parse(["Story: simple addition","Scenario: first scenario", "Scenario: second scenario"])
			  end
			  
			  it "should create a Scenario for a new Scenario after a Given" do
			    @story_mediator.should_receive(:create_story)
			    @story_mediator.should_receive(:create_given)
			    @story_mediator.should_receive(:create_scenario).with("first scenario")
			    @story_mediator.should_receive(:create_scenario).with("second scenario")
					@parser.parse(["Story: simple addition","Scenario: first scenario", "Given foo", "Scenario: second scenario"])
			  end
			  
			  it "should raise when a Given follows a Story" do
			    lambda {
  					@parser.parse(["Story: foo", "Given bar"])
			    }.should raise_error(IllegalStepError, /^Illegal attempt to create a Given after a Story/)
			  end
			  
			  it "should raise when a Then follows a Story" do
			    lambda {
  					@parser.parse(["Story: foo", "When bar"])
			    }.should raise_error(IllegalStepError, /^Illegal attempt to create a When after a Story/)
			  end
			  
			  it "should raise when a Then follows a Story" do
			    lambda {
  					@parser.parse(["Story: foo", "Then bar"])
			    }.should raise_error(IllegalStepError, /^Illegal attempt to create a Then after a Story/)
			  end
			end
			
			describe StoryParser, "in Given state" do
			  before(:each) do
			    @story_mediator = mock("story_mediator")
		    	@parser = StoryParser.new(@story_mediator)
			    @story_mediator.stub!(:create_story)
			    @story_mediator.stub!(:create_scenario)
			    @story_mediator.should_receive(:create_given).with("first")
			  end
			  
			  it "should create a Story for Story" do
          @story_mediator.should_receive(:create_story).with("number two","")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "Story: number two"])
			  end
			  
			  it "should create a Scenario for Scenario" do
          @story_mediator.should_receive(:create_scenario).with("number two")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "Scenario: number two"])
			  end

			  it "should create a second Given for Given" do
          @story_mediator.should_receive(:create_given).with("second")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "Given second"])
			  end
			  
			  it "should create a second Given for And" do
          @story_mediator.should_receive(:create_given).with("second")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "And second"])
			  end
			  
			  it "should create a When for When" do
          @story_mediator.should_receive(:create_when).with("ever")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "When ever"])
			  end
			  
			  it "should create a Then for Then" do
          @story_mediator.should_receive(:create_then).with("and there")
					@parser.parse(["Story: s", "Scenario: s", "Given first", "Then and there"])
			  end
			  
			  it "should ignore other" do
					@parser.parse(["Story: s", "Scenario: s", "Given first", "this is ignored"])
			  end
			end
		end
	end
end