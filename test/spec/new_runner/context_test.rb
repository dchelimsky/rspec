require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def test_should_add_itself_to_reporter_when_run
        reporter = Mock.new "reporter"
        context = Context.new("context") {}
        reporter.should_receive(:context_started).with context
        reporter.should_receive(:context_ended).with context
        context.run(reporter)
        reporter.__verify
      end
      
      def test_should_reply_to_describe_with_its_name
        reporter = Mock.new "reporter"
        context = Context.new("context") {}
        reporter.should_receive(:context_name).with("context")
        context.describe(reporter)
        reporter.__verify
      end

    end
  end
end