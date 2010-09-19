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
  
  # A SharedExampleGroup is an example group that doesn't get run.
  # You can create one like this:
  share_examples_for "most things" do
    def helper_method
      "helper method"
    end
    
    it "should do what things do" do
      @thing.what_things_do.should == "stuff"
    end
  end

  describe OneThing do
    # Now you can include the shared example group like this, which 
    # feels more like what you might say ...
    it_should_behave_like "most things"
    
    before(:each) { @thing = OneThing.new }
    
    it "should have access to helper methods defined in the shared example group" do
      helper_method.should == "helper method"
    end
  end
end
