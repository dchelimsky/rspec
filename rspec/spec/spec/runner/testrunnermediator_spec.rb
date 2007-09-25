require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Test
  module Unit
    module UI
      describe TestRunnerMediator, "#initialize" do
        it "should tell rspec_options to finish when suite is finished" do
          suite = Spec::DSL::ExampleSuite.new("foobar", nil)
          mediator = TestRunnerMediator.new(suite)
          rspec_options.should_receive(:finish)
          mediator.notify_listeners(TestRunnerMediator::FINISHED, 50)
        end
        
        it "adds listeners when there is no custom_runner" do
          suite = Spec::DSL::ExampleSuite.new("foobar", nil)

          options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
          TestRunnerMediator.current_rspec_options(options) do
            options.custom_runner?.should be_false
            mediator = TestRunnerMediator.new(suite)
            class << mediator
              public :channels
            end
            mediator.channels[TestRunnerMediator::STARTED].should_not be_nil
            mediator.channels[TestRunnerMediator::FINISHED].should_not be_nil
          end
        end

        it "does not add listeners when there is a custom_runner" do
          suite = Spec::DSL::ExampleSuite.new("foobar", nil)

          options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
          options.runner_arg = "Custom::BehaviourRunner"
          TestRunnerMediator.current_rspec_options(options) do
            options.custom_runner?.should be_true
            mediator = TestRunnerMediator.new(suite)
            class << mediator
              public :channels
            end
            mediator.channels[TestRunnerMediator::STARTED].should be_nil
            mediator.channels[TestRunnerMediator::FINISHED].should be_nil
          end
        end
      end
    end
  end
end