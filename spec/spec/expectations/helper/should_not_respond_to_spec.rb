require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldNotRespondTo" do
    specify "should fail when target responds to" do
        lambda do
          "".should_not_respond_to(:length)
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should pass when target doesnt respond to" do
        lambda do
          "".should_not_respond_to(:connect)
        end.should_not_raise
      
    end
  
end
end
end
end