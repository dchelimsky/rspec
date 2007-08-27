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
        
        # when
        ex = exception_from do
          step_mother.find(:given, "doesn't exist")
        end
        
        # then
        ensure_that ex, is_an(UnknownStepException)
        ensure_that ex.message, is("doesn't exist")
      end
    end
  end
end
