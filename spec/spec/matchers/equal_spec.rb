require File.dirname(__FILE__) + '/../../spec_helper.rb'
module Spec
  module Matchers
    describe "equal" do

      inspect = lambda {|o|
          "#<Class:#<#{o.class}:#{o.object_id}>>  => #{o.inspect})"}

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
        actual = "2"
        target = 1
        matcher = equal(target)
        matcher.matches?(actual)

        matcher.failure_message_for_should.should == 
        <<-MESSAGE

  expected #{inspect[target]}
  returned #{inspect[actual]}
     
(equal?: expected and returned are not the same object, did you mean '==')

MESSAGE
      end
      
      it "should provide message, expected and actual on #negative_failure_message" do
        actual = "2"
        target = actual
        matcher = equal(actual)
        matcher.matches?(actual)
        matcher.failure_message_for_should_not.should == <<-MESSAGE

  expected #{inspect[target]}
  returned #{inspect[actual]}

(equal?: expected and returned are the same object, did you mean '!=')

MESSAGE
      end
    end
  end
end
