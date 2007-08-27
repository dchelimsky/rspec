require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe SimpleStep do
      it 'should perform itself on an object' do
        # given
        $instance = nil
        step = SimpleStep.new 'step' do
          $instance = self
        end
        instance = Object.new
        
        # when
        step.perform(instance)
        
        # then
        $instance.should == instance
      end
      
      it 'should perform itself with parameters' do
        # given
        $result = nil
        step = SimpleStep.new 'step' do |value|
          $result = value
        end
        instance = Object.new
        
        # when
        step.perform(instance, 3)
        
        # then
        $result.should == 3
      end
    end
  end
end
