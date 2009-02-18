require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Matchers
    [:be_instance_of, :be_an_instance_of].each do |method|
      describe "#{method}" do
        it "passes if object is instance of given class" do
          5.should send(method, Fixnum)
        end

        it "failse if object is instance of subclass of expected class" do
          lambda { 5.should send(method, Numeric) }.should fail_with(%Q{expected instance of Numeric, got 5})
        end

        it "fails with failure message unless object is kind of given class" do
          lambda { "foo".should send(method, Array) }.should fail_with(%Q{expected instance of Array, got "foo"})
        end

        it "fails with negative failure message if object is kind of given class" do
          lambda { "foo".should_not send(method, String) }.should fail_with(%Q{expected "foo" not to be an instance of String})
        end

        it "provides a description" do
          Spec::Matchers::BeInstanceOf.new(Class).description.should == "be an instance of Class"
        end
      end
    end
  end
end
