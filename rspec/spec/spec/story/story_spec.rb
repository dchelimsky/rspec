require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe Story do
      it 'should run itself in a given object' do
        # given
        $instance = nil
        story = Story.new 'title', 'narrative' do
          $instance = self
        end
        object = Object.new
        
        # when
        story.run_in(object)
        
        # then
        $instance.should be(object)
      end
      
      it 'should not raise an error if no block is supplied' do
        # when
        error = exception_from do
          Story.new 'title', 'narrative'
        end
        
        # then
        error.should be_nil
      end
      
      it "should raise when error raised running in another object" do
        #given
        story = Story.new 'title', 'narrative' do
          raise "this is raised in the story"
        end
        object = Object.new
        
        # when/then
        lambda do
          story.run_in(object)
        end.should raise_error
      end
    end
  end
end
