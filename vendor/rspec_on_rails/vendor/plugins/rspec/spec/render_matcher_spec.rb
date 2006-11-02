require File.dirname(__FILE__) + '/spec_helper'

context "a RenderMatcher" do
  
  specify "should raise if an expectation is set but set_rendered is never called" do
    spec = Spec::Runner::Specification.new("name") do
      Spec::Rails::RenderMatcher.new.set_expectation(:template => 'non_existent_template')
    end
      
    reporter = mock("mock")
    reporter.should_receive(:spec_started).with("name")
    reporter.should_receive(:spec_finished) do |name, error|
      error.should_not_be nil
      error.backtrace.detect {|line| line =~ /render_matcher_spec.rb:17/}.should_not_be nil
      error.message.should_eql "Mock 'controller' expected :match_render_call with [{:template=>\"non_existent_template\"}] once, but received it 0 times"
    end
    spec.run(reporter)
  end
  
  specify "should raise if an expectation is set but set_rendered is never called",
    :should_raise => Spec::Mocks::MockExpectationError do
    Spec::Rails::RenderMatcher.new.set_expectation(:template => 'non_existent_template')
  end
  
  specify "should raise if an expectation is set but and not met by call to set_rendered" do
    matcher = Spec::Rails::RenderMatcher.new
    matcher.set_expectation(:template => 'expected')
    lambda do
      matcher.set_rendered(:template => 'actual')
    end.should_fail_with "<{:template=>\"expected\"}> should == <{:template=>\"actual\"}>"
  end
  
  specify "should not raise if an expectation is set and it is met" do
    spec = Spec::Runner::Specification.new("name") do
      matcher = Spec::Rails::RenderMatcher.new
      matcher.set_expectation(:template => 'expected')
      matcher.set_rendered(:template => 'expected')
    end
      
    reporter = mock("mock")
    reporter.should_receive(:spec_started).with("name")
    reporter.should_receive(:spec_finished) do |name, error|
      error.should_be nil
    end
    spec.run(reporter)
  end
end


