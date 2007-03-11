require File.dirname(__FILE__) + '/../../spec_helper.rb'

behaviour "Matchers should be able to generate their own descriptions" do
  setup do
    @desc = nil
    @callback = lambda { |desc| @desc = desc }
    Spec::Matchers.description_generated(&@callback)
  end
  
  example "should == expected" do
    "this".should == "this"
    @desc.should == "should == \"this\""
  end
  
  example "should not == expected" do
    "this".should_not == "that"
    @desc.should == "should not == \"that\""
  end
  
  example "should be empty (arbitrary predicate)" do
    [].should be_empty
    @desc.should == "should be empty"
  end
  
  example "should not be empty (arbitrary predicate)" do
    [1].should_not be_empty
    @desc.should == "should not be empty"
  end
  
  example "should be true" do
    true.should be_true
    @desc.should == "should be true"
  end
  
  example "should be false" do
    false.should be_false
    @desc.should == "should be false"
  end
  
  example "should be nil" do
    nil.should be_nil
    @desc.should == "should be nil"
  end
  
  example "should be > n" do
    5.should be > 3
    @desc.should == "should be > 3"
  end
  
  example "should be close" do
    5.0.should be_close(5.0, 0.5)
    @desc.should == "should be close to 5.0 (+- 0.5)"
  end

  example "should be predicate arg1, arg2 and arg3" do
    5.0.should be_between(0,10)
    @desc.should == "should be between 0 and 10"
  end

  example "should be_few_words predicate should be transformed to 'be few words'" do
    5.should be_kind_of(Fixnum)
    @desc.should == "should be kind of Fixnum"
  end

  example "should preserve a proper prefix for be predicate" do
    5.should be_a_kind_of(Fixnum)
    @desc.should == "should be a kind of Fixnum"
    5.should be_an_instance_of(Fixnum)
    @desc.should == "should be an instance of Fixnum"
  end
  
  example "should equal" do
    expected = "expected"
    expected.should equal(expected)
    @desc.should == "should equal \"expected\""
  end
  
  example "should_not equal" do
    5.should_not equal(37)
    @desc.should == "should not equal 37"
  end
  
  example "should eql" do
    "string".should eql("string")
    @desc.should == "should eql \"string\""
  end
  
  example "should not eql" do
    "a".should_not eql(:a)
    @desc.should == "should not eql :a"
  end
  
  example "should have_key" do
    {:a => "a"}.should have_key(:a)
    @desc.should == "should have key :a"
  end
  
  example "should have n items" do
    team.should have(3).players
    @desc.should == "should have 3 players"
  end
  
  example "should have at least n items" do
    team.should have_at_least(2).players
    @desc.should == "should have at least 2 players"
  end
  
  example "should have at most n items" do
    team.should have_at_most(4).players
    @desc.should == "should have at most 4 players"
  end
  
  example "should include" do
    [1,2,3].should include(3)
    @desc.should == "should include 3"
  end
  
  example "should match" do
    "this string".should match(/this string/)
    @desc.should == "should match /this string/"
  end
  
  example "should raise_error" do
    lambda { raise }.should raise_error
    @desc.should == "should raise Exception"
  end
  
  example "should raise_error with type" do
    lambda { raise }.should raise_error(RuntimeError)
    @desc.should == "should raise RuntimeError"
  end
  
  example "should raise_error with type and message" do
    lambda { raise "there was an error" }.should raise_error(RuntimeError, "there was an error")
    @desc.should == "should raise RuntimeError with \"there was an error\""
  end
  
  example "should respond_to" do
    [].should respond_to(:insert)
    @desc.should == "should respond to #insert"
  end
  
  example "should throw symbol" do
    lambda { throw :what_a_mess }.should throw_symbol
    @desc.should == "should throw a Symbol"
  end
  
  example "should throw symbol (with named symbol)" do
    lambda { throw :what_a_mess }.should throw_symbol(:what_a_mess)
    @desc.should == "should throw :what_a_mess"
  end
  
  def team
    Class.new do
      def players
        [1,2,3]
      end
    end.new
  end
  
  teardown do
    Spec::Matchers.unregister_callback(:description_generated, @callback)
  end
end