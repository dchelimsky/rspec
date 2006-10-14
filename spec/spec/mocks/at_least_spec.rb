require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Mocks
context "AtLeast" do
    setup do
        @mock = Mock.new("test mock", {
          :auto_verify => false
        })
      
    end
    specify "should fail at least n times method is never called" do
        @mock.should_receive(:random_call).at_least(4).times
        lambda do
          @mock.__verify
        end.should_raise(MockExpectationError)
      
    end
    specify "should fail when at least n times method is called less than n times" do
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        lambda do
          @mock.__verify
        end.should_raise(MockExpectationError)
      
    end
    specify "should fail when at least once method is never called" do
        @mock.should_receive(:random_call).at_least(:once)
        lambda do
          @mock.__verify
        end.should_raise(MockExpectationError)
      
    end
    specify "should fail when at least twice method is called once" do
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        lambda do
          @mock.__verify
        end.should_raise(MockExpectationError)
      
    end
    specify "should fail when at least twice method is never called" do
        @mock.should_receive(:random_call).at_least(:twice)
        lambda do
          @mock.__verify
        end.should_raise(MockExpectationError)
      
    end
    specify "should pass when at least n times method is called exactly n times" do
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      
    end
    specify "should pass when at least n times method is called n plus 1 times" do
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      
    end
    specify "should pass when at least once method is called once" do
        @mock.should_receive(:random_call).at_least(:once)
        @mock.random_call
        @mock.__verify
      
    end
    specify "should pass when at least once method is called twice" do
        @mock.should_receive(:random_call).at_least(:once)
        @mock.random_call
        @mock.random_call
        @mock.__verify
      
    end
    specify "should pass when at least twice method is called three times" do
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      
    end
    specify "should pass when at least twice method is called twice" do
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        @mock.random_call
        @mock.__verify
      
    end
    specify "should use last return value for subsequent calls" do
        @mock.should_receive(:multi_call).at_least(:once).with(:no_args).and_return([11, 22])
        @mock.multi_call.should_equal(11)
        @mock.multi_call.should_equal(22)
        @mock.multi_call.should_equal(22)
        @mock.__verify
      
    end
  
end
end
end