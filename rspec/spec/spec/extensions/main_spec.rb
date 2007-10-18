require File.dirname(__FILE__) + '/../../spec_helper.rb'

class MainObjectImposter
  include Spec::Extensions::Main
end

describe "The main object extended by MainExtensions" do
  before(:each) do
    @main = MainObjectImposter.new
    @original_rspec_options = $rspec_options
    $rspec_options = nil
  end

  after do
    $rspec_options = @original_rspec_options
  end

  it "should create an Options object" do
    @main.send(:rspec_options).should be_instance_of(Spec::Runner::Options)
    @main.send(:rspec_options).should === $rspec_options
  end
  
  specify {@main.should respond_to(:describe)}
  specify {@main.should respond_to(:context)}

  it "should raise when no block given to describe" do
    lambda { @main.describe "foo" }.should raise_error(ArgumentError)
  end

  it "should raise when no description given to describe" do
    lambda { @main.describe do; end }.should raise_error(ArgumentError)
  end
  
  it "should create an rspec_story_step_matchers" do
    @rspec_story_step_matchers, $rspec_story_step_matchers = $rspec_story_step_matchers, Spec::Story::StepMatchers.new
    block = lambda {}
    $rspec_story_step_matchers.should_receive(:create_matcher).with(:type, "name", &block)
    begin
      @main.step_matcher(:type, "name", &block)
    ensure
      $rspec_story_step_matchers, @rspec_story_step_matchers = @rspec_story_step_matchers, nil
    end
  end
end