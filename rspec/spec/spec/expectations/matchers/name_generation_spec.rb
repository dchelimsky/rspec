require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "Matchers should be able to generate a name" do
  setup do
    @name = nil
    @callback = lambda { |name| @name = name }
    Spec::Expectations::Matchers.name_generated(&@callback)
  end
  
  specify "should equal" do
    expected = "expected"
    expected.should equal(expected)
    @name.should == "should equal(\"expected\")"
  end
  
  specify "should_not equal" do
    5.should_not equal(37)
    @name.should == "should_not equal(37)"
  end
  
  specify "should eql" do
    "string".should eql("string")
    @name.should == "should eql(\"string\")"
  end
  
  specify "should eql" do
    "a".should_not eql(:a)
    @name.should == "should_not eql(:a)"
  end
  
  teardown do
    Spec::Expectations::Matchers.unregister_callback(:name_generated, @callback)
  end
end