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
      end
    end
  end
end