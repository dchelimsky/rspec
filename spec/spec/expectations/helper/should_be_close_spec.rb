require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper

      context "ShouldBeClose" do
        specify "should not raise when values are within bounds" do
          lambda do
            3.5.should_be_close(3.5, 0.5)
            3.5.should_be_close(3.1, 0.5)
            3.5.should_be_close(3.01, 0.5)
            3.5.should_be_close(3.9, 0.5)
            3.5.should_be_close(3.99, 0.5)
          end.should_not_raise
        end
    
        specify "should raise when values are outside bounds" do
          lambda do
            3.5.should_be_close(3.0, 0.5)
          end.should_raise(ExpectationNotMetError)
          lambda do
            3.5.should_be_close(2.0, 0.5)
          end.should_raise(ExpectationNotMetError)
          lambda do
            3.5.should_be_close(4.0, 0.5)
          end.should_raise(ExpectationNotMetError)
          lambda do
            3.5.should_be_close(5.0, 0.5)
          end.should_raise(ExpectationNotMetError)
        end
      end
    end
  end
end