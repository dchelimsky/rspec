require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Test
  module Unit
    module UI
      describe TestRunnerMediator, "#initialize" do
        it "should tell behaviour_runner to finish when suite is finished" do
          suite = Spec::DSL::ExampleSuite.new("foobar", nil)
          mediator = TestRunnerMediator.new(suite)
          behaviour_runner.options.should_receive(:finish)
          mediator.notify_listeners(TestRunnerMediator::FINISHED, 50)
        end
      end
    end
  end
end