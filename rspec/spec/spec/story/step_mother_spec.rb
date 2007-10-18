require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe StepMother do
      before(:each) do
        @step_matchers, $rspec_story_step_matchers = $rspec_story_step_matchers, mock("step matcher collection")
        $rspec_story_step_matchers.stub!(:find)
      end
      
      it 'should store a step by name and type' do
        # given
        step_mother = StepMother.new
        step = SimpleStep.new("a given", &lambda {})
        step_mother.store(:given, "a given", step)
        
        # when
        found = step_mother.find(:given, "a given")
        
        # then
        found.should == step
      end
      
      it 'should NOT raise an error if a step is missing' do
        # given
        step_mother = StepMother.new
        
        # then
        lambda do
          # when
          step_mother.find(:given, "doesn't exist")
        end.should_not raise_error
      end
      
      it "should create a default step which raises a pending error" do
        # given
        step_mother = StepMother.new
        
        # when
        step = step_mother.find(:given, "doesn't exist")
        
        # then
        step.should be_an_instance_of(SimpleStep)
        
        lambda do
          step.perform(Object.new, nil)
        end.should raise_error(Spec::DSL::ExamplePendingError, /Unimplemented/)
      end
      
      it 'should clear itself' do
        # given
        step_mother = StepMother.new
        step = SimpleStep.new("a given") do end
        step_mother.store(:given, "a given", step)

        # when
        step_mother.clear
        
        # then
        step_mother.should be_empty
      end
      
      it "should look for a step matcher" do
        #given
        step_mother = StepMother.new
        
        during {
          #when
          step_mother.find(:given, "some text")
        }.expect {
          #then
          $rspec_story_step_matchers.should_receive(:find).with(:given, "some text")
        }
      end
      
      it "should store a step matcher" do
        #given
        $rspec_story_step_matchers = StepMatchers.new
        matcher = $rspec_story_step_matchers.create_matcher(:given, "a guy named $name") {}
        step_mother = StepMother.new
        
        #when
        found_matcher = step_mother.find(:given, "a guy named Joe")

        #then
        found_matcher.should == matcher
      end
      
      after(:each) do
        $rspec_story_step_matchers, @step_matchers = @step_matchers, nil
      end
    end
  end
end
