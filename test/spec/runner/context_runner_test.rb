require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextRunnerTest < Test::Unit::TestCase
    
      def test_should_call_run_on_context
        context1 = Api::Mock.new "context1", :null_object=>true
        context2 = Api::Mock.new "context2", :null_object=>true
        context1.should.receive(:run)
        context1.should.receive(:number_of_specs).and.return(0)
        context2.should.receive(:run)
        context2.should.receive(:number_of_specs).and.return(0)
        
        reporter = Api::Mock.new 'reporter'
        reporter.should_receive(:start).with(0)
        reporter.should_receive(:end)
        reporter.should_receive(:dump)

        runner = ContextRunner.new(reporter, false, false)
        runner.add_context context1
        runner.add_context context2        

        runner.run

        context1.__verify
        context2.__verify
        reporter.__verify
      end
      
      def test_should_support_single_spec
        legal_context = Api::Mock.new "legal context"
        legal_context.should_receive(:matches?).at_least(:once).and_return(true)
        legal_context.should_receive(:run)
        legal_context.should_receive(:isolate)
        legal_context.should_receive(:number_of_specs).and_return(1)
        
        illegal_context = Api::Mock.new "illegal context"
        illegal_context.should_receive(:matches?).and_return(false)
        illegal_context.should_receive(:run).never
        illegal_context.should_receive(:number_of_specs).never
        
        reporter = Api::Mock.new 'reporter'

        runner = ContextRunner.new(reporter, false, false, "legal context legal spec")
        runner.add_context legal_context
        runner.add_context illegal_context
        
        reporter.should_receive(:start)
        reporter.should_receive(:end)
        reporter.should_receive(:dump)
        
        runner.run

        legal_context.__verify
        illegal_context.__verify
        reporter.__verify
      end
      
    end
  end
end