require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "ContextRunner" do
    specify "should call run on context" do
        context1=context2=reporter=
        context1=Spec::Mocks::Mock.new("context1", {
          :null_object => true
        })
        context2=Spec::Mocks::Mock.new("context2", {
          :null_object => true
        })
        context1.should_receive(:run)
        context1.should_receive(:number_of_specs).and_return(0)
        context2.should_receive(:run)
        context2.should_receive(:number_of_specs).and_return(0)
        reporter=Spec::Mocks::Mock.new("reporter")
        reporter.should_receive(:start).with(0)
        reporter.should_receive(:end)
        reporter.should_receive(:dump)
        runner=ContextRunner.new(reporter, false)
        runner.add_context(context1)
        runner.add_context(context2)
        runner.run(false)
        context1.__verify
        context2.__verify
        reporter.__verify
      
    end
    specify "should support single spec" do
        desired_context=other_context=reporter=
        desired_context=Spec::Mocks::Mock.new("desired context")
        desired_context.should_receive(:matches?).at_least(:once).and_return(true)
        desired_context.should_receive(:run)
        desired_context.should_receive(:run_single_spec)
        desired_context.should_receive(:number_of_specs).and_return(1)
        other_context=Spec::Mocks::Mock.new("other context")
        other_context.should_receive(:matches?).and_return(false)
        other_context.should_receive(:run).never
        other_context.should_receive(:number_of_specs).never
        reporter=Spec::Mocks::Mock.new("reporter")
        runner=ContextRunner.new(reporter, false, "desired context legal spec")
        runner.add_context(desired_context)
        runner.add_context(other_context)
        reporter.should_receive(:start)
        reporter.should_receive(:end)
        reporter.should_receive(:dump)
        runner.run(false)
        desired_context.__verify
        other_context.__verify
        reporter.__verify
      
    end
  
end
end
end