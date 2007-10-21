require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Runner
      describe PlainTextStoryRunner do
        it "should provide access to matchers" do
          runner = PlainTextStoryRunner.new
          
          runner.step_matchers do |add|
            add.given("baz") {}
          end
          
          runner.step_matchers.find(:given, "baz").should_not be_nil
        end
      end
    end
  end
end