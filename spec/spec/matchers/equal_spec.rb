require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Matchers
    describe "equal" do
      it "should match when actual.equal?(expected)" do
        1.should equal(1)
      end

      it "should not match when !actual.equal?(expected)" do
        1.should_not equal("1")
      end
      
      it "should describe itself" do
        matcher = equal(1)
        matcher.matches?(1)
        matcher.description.should == "equal 1"
      end
      
      it "should provide message, expected and actual on #failure_message" do
        matcher = equal("1")
        matcher.matches?(1)
        matcher.failure_message_for_should.should == "\nexpected \"1\"\n     got 1\n     \n(compared using equal?)\n"
      end
      
      it "should provide message, expected and actual on #negative_failure_message" do
        matcher = equal(1)
        matcher.matches?(1)
        matcher.failure_message_for_should_not.should == "\nexpected 1 not to equal 1\n\n(compared using equal?)\n"
      end
    end
  end
end
