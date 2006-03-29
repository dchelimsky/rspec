require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def test_should_add_itself_to_reporter_when_run
        reporter = Mock.new "reporter"
        context = Context.new("context") {}
        reporter.should_receive(:context_started).with "context"
        context.run(reporter)
        reporter.__verify
      end

    end
  end
end