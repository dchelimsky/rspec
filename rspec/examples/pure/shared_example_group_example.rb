require File.dirname(__FILE__) + '/spec_helper'

module SharedExampleGroupExample
  class OneThing
    def what_things_do
      "stuff"
    end
  end
  
  class AnotherThing
    def what_things_do
      "stuff"
    end
  end
  
  class YetAnotherThing
    def what_things_do
      "stuff"
    end
  end
  
  # A SharedExampleGroup is a module, so you can assign
  # it to a constant if you want ....
  AllThings = describe "All Things", :shared => true do
    def helper_method
      "helper method"
    end
    
    it "should do what things do" do
      @thing.what_things_do.should == "stuff"
    end
  end
  
  # TODO - it would be nice to be able to say this instead of the above:
  
  # class AllThings < Spec::SharedExampleGroup
  #   ...
  # end

  describe OneThing do
    # ... then you can include the behaviour like this, which 
    # feels more like what you might say ...
    it_should_behave_like "All Things"
    before(:each) { @thing = OneThing.new }
    
    it "should have access to helper methods defined in the shared behaviour" do
      helper_method.should == "helper method"
    end
  end

  describe AnotherThing do
    # ... or you can include the behaviour like this, which
    # feels more like the programming language we love.
    it_should_behave_like AllThings
    
    before(:each) { @thing = AnotherThing.new }
  end

  describe YetAnotherThing do
    # ... or you can include the behaviour like this, which
    # feels more like the programming language we love.
    include AllThings
    
    before(:each) { @thing = AnotherThing.new }
  end
end
