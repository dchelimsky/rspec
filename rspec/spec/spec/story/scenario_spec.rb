require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe Scenario do
      it 'should fail to construct if no body is supplied' do
        # given
        story = StoryBuilder.new.to_story
        
        # when
        error = exception_from do
          Scenario.new story, 'name'
        end
        
        # then
        error.should be_kind_of(ArgumentError)
      end
    end
  end
end
