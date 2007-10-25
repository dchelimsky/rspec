require File.dirname(__FILE__) + '/../../spec_helper.rb'

class MainObjectImposter
  include Spec::Extensions::Main
end

module Spec
  module Extensions
    describe Main do
      before(:each) do
        @main = MainObjectImposter.new
        @original_rspec_options, $rspec_options = $rspec_options, nil
        @original_rspec_story_steps, $rspec_story_steps = $rspec_story_steps, nil
      end

      after(:each) do
        $rspec_options = @original_rspec_options
        $rspec_story_steps = @original_rspec_story_steps
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
        Spec::Story::Runner::PlainTextStoryRunner.should_receive(:new).and_return(mock("runner", :null_object => true))
        @main.run_story
      end

      it "should yield the runner if arity == 1" do
        File.should_receive(:read).with("some/path").and_return("Story: foo")
        $main_spec_runner = nil
        @main.run_story("some/path") do |runner|
          $main_spec_runner = runner
        end
        $main_spec_runner.should be_an_instance_of(Spec::Story::Runner::PlainTextStoryRunner)
      end
  
      it "should run in the runner if arity == 0" do
        File.should_receive(:read).with("some/path").and_return("Story: foo")
        $main_spec_runner = nil
        @main.run_story("some/path") do
          $main_spec_runner = self
        end
        $main_spec_runner.should be_an_instance_of(Spec::Story::Runner::PlainTextStoryRunner)
      end
  
      it "should tell the PlainTextStoryRunner to run with run_story" do
        runner = mock("runner")
        Spec::Story::Runner::PlainTextStoryRunner.should_receive(:new).and_return(runner)
        runner.should_receive(:run)
        @main.run_story
      end  
  
      it "should have no steps for a non existent key" do
        @main.steps_for(:key).find(:given, "foo").should be_nil
      end
  
      it "should create steps for a key" do
        $main_spec_invoked = false
        @main.steps_for(:key) do
          Given("foo") {
            $main_spec_invoked = true
          }
        end
        @main.steps_for(:key).find(:given, "foo").perform(Object.new, "foo")
        $main_spec_invoked.should be_true
      end
  
      it "should append steps to steps_for a given key" do
        @main.steps_for(:key) do
          Given("first") {}
        end
        @main.steps_for(:key) do
          Given("second") {}
        end
        @main.steps_for(:key).should have_step(:given, "first")
        @main.steps_for(:key).should have_step(:given, "second")
      end
  
      it "should dup an existing group on with_steps_for" do
        first_group = @main.steps_for(:key) do
          Given("first") {}
        end
        second_group = @main.with_steps_for(:key) do
          Given("second") {}
        end
    
        first_group.should have_step(:given, "first")
        first_group.should_not have_step(:given, "second")
    
        second_group.should have_step(:given, "first")
        second_group.should have_step(:given, "second")
      end
      
      it "should run a story with steps for foo" do
        pending("ugh!!!!! this should work")
        $step_was_invoked = false
        @main.steps_for(:key) do
          Given("first") {
            $step_was_invoked = true
          }
        end
        File.should_receive(:read).with('path/to/file').and_return("Story: foo\nScenario: bar\nGiven first\nWhen second\nThen third")
        @main.with_steps_for(:key) do
          run 'path/to/file'
        end
        $step_was_invoked.should be_true
      end

      def have_step(type, name)
        return simple_matcher(%[step group containing a #{type} named #{name.inspect}]) do |actual|
          Spec::Story::MatchingStep === actual.find(type, name)
        end
      end
    end
  end
end