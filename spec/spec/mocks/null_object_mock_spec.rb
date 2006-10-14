require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Mocks
context "NullObjectMock" do
    setup do
        @mock = Mock.new("null_object", {
          :null_object => true
        })
      
    end
    specify "should allow explicit expectation" do
        @mock.should_receive(:something)
        @mock.something
        @mock.__verify
      
    end
    specify "should fail verification when explicit exception not met" do
        lambda do
            @mock.should_receive(:something)
            @mock.__verify
          
        end.should_raise(MockExpectationError)
      
    end
    specify "should ignore unexpected methods" do
        @mock.random_call("a", "d", "c")
        @mock.__verify
      
    end
    specify "should pass when receiving message specified as not to be received with different args" do
        @mock.should_not_receive(:message).with("unwanted text")
        @mock.message("other text")
        @mock.__verify
      
    end
  
end
end
end