require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "Spec::Expectations::Matchers#method_missing behaviour" do
  specify "should infer a predicate from be_xxx" do
    be_empty.matches?([]).should be(true)
    be_empty.matches?([1]).should be(false)
    lambda {[1].should be_empty}.should_fail_with "expected actual.empty? to return true, got false"
    lambda {[].should_not be_empty}.should_fail_with "expected actual.empty? to return false, got true"
  end

  specify "should infer a predicate from be_a_xxx" do
    be_a_kind_of(Numeric).matches?(3).should be(true)
    be_a_kind_of(Numeric).matches?("3").should be(false)
    lambda {"3".should be_a_kind_of(Numeric)}.should_fail_with "expected actual.kind_of?(Numeric) to return true, got false"
    lambda {3.should_not be_a_kind_of(Numeric)}.should_fail_with "expected actual.kind_of?(Numeric) to return false, got true"
  end

  specify "should infer a predicate from be_an_xxx" do
    be_an_instance_of(Fixnum).matches?(3).should be(true)
    be_an_instance_of(Numeric).matches?(3).should be(false)
    lambda {3.should be_an_instance_of(Numeric)}.should_fail_with "expected actual.instance_of?(Numeric) to return true, got false"
    lambda {3.should_not be_an_instance_of(Fixnum)}.should_fail_with "expected actual.instance_of?(Fixnum) to return false, got true"
  end
  
  specify "should infer boolean from be_true and be_false" do
    true.should be_true
    false.should be_false
    lambda { true.should be_false }.should_fail_with "expected false, got true"
    lambda { false.should be_true }.should_fail_with "expected true, got false"
  end
  
  specify "should respond_to? anything starting w/ be_" do
    be_xyz
    be_a_xyz
    be_an_xyz
    be_anything_at_all
  end
  
  specify "should handle anything else normally" do
    lambda {missing_method}.should_raise NameError
  end
end
