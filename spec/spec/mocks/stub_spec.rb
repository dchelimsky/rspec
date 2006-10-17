require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    context "Stub" do
      setup do
        klass=Class.new
        klass.class_eval do
          def existing_method
            :original_value
          end
        end
        @obj = klass.new
      end

      specify "should allow for a mock message to temporarily replace the stub" do
        mock=Spec::Mocks::Mock.new("a mock")
        mock.stub!(:msg).and_return(:stub_value)
        mock.should_receive(:msg).with(:arg).and_return(:mock_value)
        mock.msg(:arg).should_equal(:mock_value)
        mock.msg.should_equal(:stub_value)
        mock.msg.should_equal(:stub_value)
        mock.__verify
      end

      specify "should allow for a mock to temporarily replace the stub" do
        @obj.stub!(:msg).and_return(:stub_value)
        @obj.should_receive(:msg).with(:arg).and_return(:mock_value)
        @obj.msg(:arg).should_equal(:mock_value)
        @obj.msg.should_equal(:stub_value)
        @obj.msg.should_equal(:stub_value)
        @obj.__verify
      end

      specify "should ignore when expected message is not received" do
        @obj.stub!(:msg)
        lambda do
          @obj.__verify
        end.should_not_raise
      end
      
      specify "should clear itself on __verify" do
        @obj.stub!(:this_should_go).and_return(:blah)
        @obj.this_should_go.should_equal :blah
        @obj.__verify
        lambda do
          @obj.this_should_go
        end.should_raise
      end
      
      specify "should ignore when expected message is received" do
        @obj.stub!(:msg)
        @obj.msg
        @obj.__verify
      end

      specify "should ignore when message is received with args" do
        @obj.stub!(:msg)
        @obj.msg(:an_arg)
        @obj.__verify
      end

      specify "should not support with" do
        lambda do
          Spec::Mocks::Mock.new("a mock").stub!(:msg).with(:arg)
        end.should_raise(NoMethodError)
      end
      
      specify "should return expected value when expected message is received" do
        @obj.stub!(:msg).and_return(:return_value)
        @obj.msg.should_equal(:return_value)
        @obj.__verify
      end

      specify "should revert to original method if existed" do
        @obj.existing_method.should_equal(:original_value)
        @obj.stub!(:existing_method).and_return(:mock_value)
        @obj.existing_method.should_equal(:mock_value)
        @obj.__verify
        @obj.existing_method.should_equal(:original_value)
      end
    end
  end
end