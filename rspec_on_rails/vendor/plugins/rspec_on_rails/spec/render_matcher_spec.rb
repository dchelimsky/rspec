require File.dirname(__FILE__) + '/spec_helper'

context "a RenderMatcher" do
  
  specify "should include correct file and line number" do
    spec = Spec::Runner::Specification.new("name") do
      Spec::Rails::RenderMatcher.new.set_expected(:template => 'non_existent_template')
    end
      
    reporter = mock("mock", :null_object => true)
    reporter.should_receive(:spec_finished) do |name, error|
      error.backtrace.detect {|line| line =~ /render_matcher_spec.rb:16/}.should_not_be nil
      #NOTE - this expectation relies on this spec being in this file (render_match_spec.rb)
      #and the line "spec.run(reporter)" below appearing on line 16
    end
    spec.run(reporter, nil, nil, nil, nil)
  end
  
  specify "should raise if an expectation is set but set_rendered is never called",
    :should_raise => [Spec::Mocks::MockExpectationError, "controller expected call to render {:template=>\"non_existent_template\"} but it was never received"] do
    Spec::Rails::RenderMatcher.new.set_expected(:template => 'non_existent_template')
  end
  
  specify "should raise if an expectation is set first but and not met by call to set_rendered",
    :should_raise => [
      Spec::Expectations::ExpectationNotMetError, 
      "{:template=>\"actual\"} should == {:template=>\"expected\"}"
    ] do
    matcher = Spec::Rails::RenderMatcher.new
    matcher.set_expected(:template => 'expected')
    matcher.set_actual(:template => 'actual')
  end
  
  specify "should raise if an expectation is set after but and not met by call to set_rendered",
    :should_raise => [
      Spec::Expectations::ExpectationNotMetError, 
      "{:template=>\"actual\"} should == {:template=>\"expected\"}"
    ] do
    matcher = Spec::Rails::RenderMatcher.new
    matcher.set_actual(:template => 'actual')
    matcher.set_expected(:template => 'expected')
  end
  
  specify "should not raise if an expectation is set before and it is met" do
    matcher = Spec::Rails::RenderMatcher.new
    matcher.set_expected(:template => 'expected')
    matcher.set_actual(:template => 'expected')
  end
  
  specify "should not raise if an expectation is set after and it is met" do
    matcher = Spec::Rails::RenderMatcher.new
    matcher.set_actual(:template => 'expected')
    matcher.set_expected(:template => 'expected')
  end
end
