require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    context "Stub" do
      setup do
        @class=Class.new
        @class.class_eval do
          def self.existing_class_method
            :original_value
          end

          def existing_instance_method
            :original_value
          end
        end
        @obj = @class.new
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

      specify "should revert to original instance method if existed" do
        @obj.existing_instance_method.should_equal(:original_value)
        @obj.stub!(:existing_instance_method).and_return(:mock_value)
        @obj.existing_instance_method.should_equal(:mock_value)
        @obj.__verify
        @obj.existing_instance_method.should_equal(:original_value)
      end
      
      specify "should revert to original class method if existed" do
        @class.existing_class_method.should_equal(:original_value)
        @class.stub!(:existing_class_method).and_return(:mock_value)
        @class.existing_class_method.should_equal(:mock_value)
        @class.__verify
        @class.existing_class_method.should_equal(:original_value)
      end

      specify "should clear itself on __verify" do
        @obj.stub!(:this_should_go).and_return(:blah)
        @obj.this_should_go.should_equal :blah
        @obj.__verify
        lambda do
          @obj.this_should_go
        end.should_raise
      end
      
    end
  end
end