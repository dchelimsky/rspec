require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module ExampleExpectations
  
  def passing_expectation
    Class.new do
      def met_by?(target)
        true
      end

      def negative_failure_message
        "negative expectation failed"
      end
    end.new
  end
  
  def failing_expectation
    Class.new do
      def met_by?(target)
        false
      end

      def failure_message
        "expectation failed"
      end
    end.new
  end
  
end

context "ExpectationHandler behaviour" do
  include ExampleExpectations
  setup do
    @target = Object.new
  end

  specify "should pass if met_by? returns true" do
    @target.should passing_expectation
  end

  specify "should fail if met_by? returns false" do
    lambda {@target.should failing_expectation}.should_fail_with "expectation failed"
  end

  specify "should pass negative expectation if met_by? returns false" do
    @target.should_not failing_expectation
  end

  specify "should fail negative expectation if met_by? returns true" do
    lambda {@target.should_not passing_expectation}.should_fail_with "negative expectation failed"
  end

end