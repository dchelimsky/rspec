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

        runner = ContextRunner.new(reporter, false, STDERR)
        runner.add_context context1
        runner.add_context context2        

        runner.run

        context1.__verify
        context2.__verify
        reporter.__verify
      end
      
    end
  end
end