require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class ContextRunnerTest < Test::Unit::TestCase
      def test_should_call_run_doc_on_context
        context1 = Api::Mock.new "context1"
        context2 = Api::Mock.new "context2"
        context1.should.receive(:run_docs)
        context2.should.receive(:run_docs)
        runner = ContextRunner.new ["-d"], StringIO.new
        runner.add_context context1
        runner.add_context context2        
        runner.run
        context1.__verify
        context2.__verify
      end
    end
  end
end