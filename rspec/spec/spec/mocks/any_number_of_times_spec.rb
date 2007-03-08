require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    
    context "AnyNumberOfTimes" do
      setup do
        @mock = Mock.new("test mock")
      end

      specify "should pass if any number of times method is called many times" do
        @mock.should_receive(:random_call).any_number_of_times
        (1..10).each do
          @mock.random_call
        end
      end

      specify "should pass if any number of times method is called once" do
        @mock.should_receive(:random_call).any_number_of_times
        @mock.random_call
      end
      
      specify "should pass if any number of times method is not called" do
        @mock.should_receive(:random_call).any_number_of_times
      end
    end

  end
end