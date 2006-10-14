require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Mocks
context "PartialMock" do
    setup do
        @object = Object.new
      
    end
    specify "should not receive  should mock out the method" do
        @object.should_not_receive(:fuhbar)
        @object.fuhbar
        lambda do
          @object.__verify
        end.should_raise(Spec::Mocks::MockExpectationError)
      
    end
    specify "should not receive  should return a negative message expectation" do
        @object.should_not_receive(:foobar).should_be_kind_of(NegativeMessageExpectation)
      
    end
    specify "should receive  should mock out the method" do
        @object.should_receive(:foobar).with(:test_param).and_return(1)
        @object.foobar(:test_param).should_equal(1)
      
    end
    specify "should receive  should return a message expectation" do
        @object.should_receive(:foobar).should_be_kind_of(MessageExpectation)
      @object.foobar
    end
    specify "should receive  should verify method was called" do
        @object.should_receive(:foobar).with(:test_param).and_return(1)
        lambda do
          @object.__verify
        end.should_raise(Spec::Mocks::MockExpectationError)
      
    end
  
end
end
end