require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    describe "A chained method stub" do
      before(:each) do
        @class = Class.new do
          def self.existing_class_method
            :original_value
          end

          def existing_instance_method
            :original_value
          end
        end
        @instance = @class.new
        @stub = Object.new
      end

      it "should return expected value from chaining two method calls" do
        @instance.stub_chain!(:msg1, :msg2).and_return(:return_value)
        @instance.msg1.msg2.should equal(:return_value)
        @instance.rspec_verify
      end

      it "should return expected value from chaining four method calls" do
        @instance.stub_chain!(:msg1, :msg2, :msg3, :msg4).and_return(:return_value)
        @instance.msg1.msg2.msg3.msg4.should equal(:return_value)
        @instance.rspec_verify
      end

      it "should return expected value from chaining only one method call" do
        @instance.stub_chain!(:msg1).and_return(:return_value)
        @instance.msg1.should equal(:return_value)
        @instance.rspec_verify
      end

      it "should return expected value when matching the specified argument filter" do
        @instance.stub_chain!({:msg1 => [ :arg1, :arg2 ]}, :msg2, :msg3).and_return(:return_value)
        @instance.msg1(:arg1, :arg2).msg2.msg3.should equal(:return_value)
        @instance.rspec_verify
      end

      it "should raise when stub chain is called with arguments different from those specified in the filter" do
        @instance.stub_chain!({:msg1 => [ :arg1, :arg2 ]}, :msg2, :msg3).and_return(:return_value)
        lambda { @instance.msg1(:arg1).msg2.msg3 }.should raise_error
        @instance.rspec_verify
      end

    end
  end
end
