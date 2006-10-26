require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    context "FailingMockArgumentConstraints" do
      setup do
        @mock = Mock.new("test mock", {
          :auto_verify => false
        })
        @reporter = Mock.new("reporter", {
          :null_object => true,
          :auto_verify => false
        })
      end
      
      specify "should reject goose when expecting a duck" do
        @mock.should_receive(:random_call).with(DuckTypeArgConstraint.new(:abs, :div))
        lambda { @mock.random_call("I don't respond to :abs or :div") }.should_raise(MockExpectationError)
      end
      
      specify "should reject non boolean" do
        @mock.should_receive(:random_call).with(:boolean)
        lambda do
          @mock.random_call("false")
        end.should_raise(MockExpectationError)
      end
      
      specify "should reject non numeric" do
        @mock.should_receive(:random_call).with(:numeric)
        lambda do
          @mock.random_call("1")
        end.should_raise(MockExpectationError)
      end
      
      specify "should reject non string" do
        @mock.should_receive(:random_call).with(:string)
        lambda do
          @mock.random_call(123)
        end.should_raise(MockExpectationError)
      end
      
      specify "should fail if regexp does not match submitted string" do
        @mock.should_receive(:random_call).with(/bcd/)
        lambda { @mock.random_call("abc") }.should_raise(MockExpectationError)
      end
      
      specify "should fail if regexp does not match submitted regexp" do
        @mock.should_receive(:random_call).with(/bcd/)
        lambda { @mock.random_call(/bcde/) }.should_raise(MockExpectationError)
      end
    end
  end
end
