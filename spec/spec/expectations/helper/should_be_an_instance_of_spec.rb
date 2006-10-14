require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "ShouldBeAnInstanceOf" do

  specify "should fail when target is not specified class" do
    lambda do
      5.should_be_an_instance_of(Integer)
    end.should_raise(Spec::Expectations::ExpectationNotMetError)
  end

  specify "should pass when target is specified class" do
    lambda do
      5.should_be_an_instance_of(Fixnum)
    end.should_not_raise
  end
end
