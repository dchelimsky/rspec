require File.dirname(__FILE__) + '/spec_helper'

module BehaveAsExample
  behave_as_guitarist = Spec::Matchers::RespondTo.new('read_notes', 'turn_down_amp')
  
  class Thing
    def read_notes; end
    def turn_down_amp; end
  end
  
  describe Thing do
    it "should behave as guitarist" do
      Thing.new.should behave_as_guitarist
    end
  end
end