require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Matchers
    [:be_instance_of, :be_an_instance_of].each do |method|
      describe "actual.should #{method}(expected)" do
        it "passes if actual is instance of expected class" do
          5.should send(method, Fixnum)
        end

        it "fails if actual is instance of subclass of expected class" do
          lambda { 5.should send(method, Numeric) }.should fail_with(%Q{expected instance of Numeric, got 5})
        end

        it "fails with failure message for should unless actual is instance of expected class" do
          lambda { "foo".should send(method, Array) }.should fail_with(%Q{expected instance of Array, got "foo"})
        end

        it "provides a description" do
          Spec::Matchers::BeInstanceOf.new(Class).description.should == "be an instance of Class"
        end
      end
      
      describe "actual.should_not #{method}(expected)" do
        
        it "fails with failure message for should_not if actual is instance of expected class" do
          lambda { "foo".should_not send(method, String) }.should fail_with(%Q{expected "foo" not to be an instance of String})
        end

      end

    end
  end
end
