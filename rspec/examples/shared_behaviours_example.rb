require File.dirname(__FILE__) + '/spec_helper'

module SharedBehaviourExample
  class Thing
    def what_things_do
      "stuff"
    end
  end

  describe "All Things", :shared => true do
    it "should do what things do" do
      @thing.what_things_do.should == "stuff"
    end
  end

  describe Thing do
    it_should_behave_like "All Things"
    before(:each) { @thing = Thing.new }
  end
end
