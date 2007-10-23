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
  
  it "should create a PlainTextStoryRunner with run_story" do
    File.should_receive(:read).with("some/path").and_return("Story: foo")
    $main_spec_step_matchers = nil
    @main.run_story("some/path") do |runner|
      $main_spec_step_matchers = runner.step_matchers
    end
    $main_spec_step_matchers.should be_an_instance_of(Spec::Story::StepMatchers)
  end
  
  it "should tell the PlainTextStoryRunner to run with run_story" do
    runner = mock("runner")
    runner.should_receive(:run)
    Spec::Story::Runner::PlainTextStoryRunner.should_receive(:new).and_return(runner)
    @main.run_story
  end
  
end