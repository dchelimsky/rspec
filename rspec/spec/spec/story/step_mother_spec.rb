require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe StepMother do
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
      
      it 'should raise an error if a step is missing' do
        # given
        step_mother = StepMother.new
        
        # then
        lambda do
          # when
          step_mother.find(:given, "doesn't exist")
        end.should raise_error(UnknownStepException, /given doesn't exist/)
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
    end
  end
end
