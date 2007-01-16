require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module ExampleExpectations
  
  class MatcherThatAcceptsArgsAndBlock
    def initialize(*args,&block)
      if args.last.is_a?Hash
        @expected = args.last[:expected]
      elsif block_given?
        @expected = block.call
      end
      @block = block
    end
    
    def met_by?(target)
      @target = target
      return @expected == target
    end
    
    def failure_message
      "expected #{@expected}, got #{@target}"
    end
    
    def negative_failure_message
      "expected not #{@expected}, got #{@target}"
    end
  end
  
  def matcher_that_accepts_args_and_block(*args, &block)
    MatcherThatAcceptsArgsAndBlock.new(*args, &block)
  end
  
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

  specify "should handle submitted args" do
    5.should matcher_that_accepts_args_and_block(:expected => 5)
    lambda { 5.should matcher_that_accepts_args_and_block(:expected => 4) }.should_fail_with "expected 4, got 5"
    5.should_not matcher_that_accepts_args_and_block(:expected => 4)
    lambda { 5.should_not matcher_that_accepts_args_and_block(:expected => 5) }.should_fail_with "expected not 5, got 5"
  end

  specify "should handle the submitted block" do
    5.should matcher_that_accepts_args_and_block { 5 }
    lambda { 5.should matcher_that_accepts_args_and_block { 4 } }.should_fail_with "expected 4, got 5"
    5.should_not matcher_that_accepts_args_and_block { 4 }
    lambda { 5.should_not matcher_that_accepts_args_and_block { 5 } }.should_fail_with "expected not 5, got 5"
  end

  specify "should fail if met_by? returns false" do
    lambda { @target.should failing_expectation }.should_fail_with "expectation failed"
  end

  specify "should pass negative expectation if met_by? returns false" do
    @target.should_not failing_expectation
  end

  specify "should fail negative expectation if met_by? returns true" do
    lambda { @target.should_not passing_expectation }.should_fail_with "negative expectation failed"
  end

end