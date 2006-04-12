require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextRunnerTest < Test::Unit::TestCase
    
      def test_should_call_run_doc_on_context
        context1 = Api::Mock.new "context1", :null_object=>true
        context2 = Api::Mock.new "context2", :null_object=>true
        context1.should.receive(:run_docs)
        context2.should.receive(:run_docs)
        runner = ContextRunner.new ["-d"], false, StringIO.new
        runner.add_context context1
        runner.add_context context2        
        runner.run
        context1.__verify
        context2.__verify
      end

      def test_should_call_run_on_context
        context1 = Api::Mock.new "context1", :null_object=>true
        context2 = Api::Mock.new "context2", :null_object=>true
        context1.should.receive(:run)
        context1.should.receive(:number_of_specs).and.return(0)
        context2.should.receive(:run)
        context2.should.receive(:number_of_specs).and.return(0)
        runner = ContextRunner.new ["-o","stringio"], false, StringIO.new
        runner.add_context context1
        runner.add_context context2        
        runner.run
        context1.__verify
        context2.__verify
      end

      def test_should_call_run_for_standalone
        context1 = Api::Mock.new "context1", :null_object=>true
        context1.should.receive(:number_of_specs).and.return(0)
        context1.should.receive(:run)
        runner = ContextRunner.standalone context1, ["-o","stringio"]
        context1.__verify
      end
      
    end
  end
end