require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "method_missing behaviour" do
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
  
  specify "should handle anything else normally" do
    lambda {missing_method}.should_raise NameError
  end
end
