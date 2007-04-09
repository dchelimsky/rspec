require File.dirname(__FILE__) + '/spec_helper'

def behave_as_guitarist
  respond_to(:read_notes, :turn_down_amp)
end

module BehaveAsExample
  
  class BluesGuitarist
    def read_notes; end
    def turn_down_amp; end
  end
  
  class RockGuitarist
    def read_notes; end
    def turn_down_amp; end
  end
  
  class ClassicGuitarist
    def read_notes; end
  end
  
  describe BluesGuitarist do
    it "should behave as guitarist" do
      BluesGuitarist.new.should behave_as_guitarist
    end
  end

  describe RockGuitarist do
    it "should behave as guitarist" do
      RockGuitarist.new.should behave_as_guitarist
    end
  end

  describe ClassicGuitarist do
    it "should not behave as guitarist" do
      ClassicGuitarist.new.should_not behave_as_guitarist
    end
  end
  
end