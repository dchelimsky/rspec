require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper
      context "ShouldBeAKindOf" do
        specify "should fail when target is not specified class" do
          lambda do
            5.should_be_a_kind_of(String)
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "should pass when target is of specified class" do
          lambda do
            5.should_be_a_kind_of(Fixnum)
          end.should_not_raise
        end
    
        specify "should pass when target is of subclass of specified class" do
          lambda do
            5.should_be_a_kind_of(Integer)
          end.should_not_raise
        end
      end
    end
  end
end