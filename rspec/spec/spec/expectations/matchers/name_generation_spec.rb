require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "Matchers should be able to generate a name" do
  setup do
    @name = nil
    @callback = lambda { |name| @name = name }
    Spec::Expectations::Matchers.name_generated(&@callback)
  end
  
  specify "should be empty (arbitrary predicate)" do
    [].should be_empty
    @name.should == "should be empty"
  end
  
  specify "should not be empty (arbitrary predicate)" do
    [1].should_not be_empty
    @name.should == "should not be empty"
  end
  
  specify "should be true" do
    true.should be_true
    @name.should == "should be true"
  end
  
  specify "should be false" do
    false.should be_false
    @name.should == "should be false"
  end
  
  specify "should be nil" do
    nil.should be_nil
    @name.should == "should be nil"
  end
  
  specify "should be close" do
    5.0.should be_close(5.0, 0.5)
    @name.should == "should be close to 5.0 (+- 0.5)"
  end
  
  specify "should equal" do
    expected = "expected"
    expected.should equal(expected)
    @name.should == "should equal \"expected\""
  end
  
  specify "should_not equal" do
    5.should_not equal(37)
    @name.should == "should not equal 37"
  end
  
  specify "should eql" do
    "string".should eql("string")
    @name.should == "should eql \"string\""
  end
  
  specify "should not eql" do
    "a".should_not eql(:a)
    @name.should == "should not eql :a"
  end
  
  specify "should have_key" do
    {:a => "a"}.should have_key(:a)
    @name.should == "should have key :a"
  end
  
  specify "should have n items" do
    team.should have(3).players
    @name.should == "should have 3 players"
  end
  
  specify "should have at least n items" do
    team.should have_at_least(2).players
    @name.should == "should have at least 2 players"
  end
  
  specify "should have at most n items" do
    team.should have_at_most(4).players
    @name.should == "should have at most 4 players"
  end
  
  specify "should include" do
    [1,2,3].should include(3)
    @name.should == "should include 3"
  end
  
  specify "should match" do
    "this string".should match(/this string/)
    @name.should == "should match /this string/"
  end
  
  specify "should raise_error" do
    lambda { raise }.should raise_error
    @name.should == "should raise Exception"
  end
  
  specify "should raise_error with type" do
    lambda { raise }.should raise_error(RuntimeError)
    @name.should == "should raise RuntimeError"
  end
  
  specify "should raise_error with type and message" do
    lambda { raise "there was an error" }.should raise_error(RuntimeError, "there was an error")
    @name.should == "should raise RuntimeError with \"there was an error\""
  end
  
  specify "should respond_to" do
    [].should respond_to(:insert)
    @name.should == "should respond to :insert"
  end
  
  specify "should throw symbol" do
    lambda { throw :what_a_mess }.should throw_symbol
    @name.should == "should throw a Symbol"
  end
  
  specify "should throw symbol (with named symbol)" do
    lambda { throw :what_a_mess }.should throw_symbol(:what_a_mess)
    @name.should == "should throw :what_a_mess"
  end
  
  def team
    Class.new do
      def players
        [1,2,3]
      end
    end.new
  end
  
  teardown do
    Spec::Expectations::Matchers.unregister_callback(:name_generated, @callback)
  end
end