require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class QuietFailureDumpTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = Reporter.new(SpecdocFormatter.new(@io, false), false, QuietBacktraceTweaker.new)
        @reporter.add_context "context"
      end
      
      def set_backtrace error
        error.set_backtrace ["/a/b/c/d/e.rb:34:in `__instance_exec'"]
      end
  
      def test_spacing_between_sections
        error = Spec::Api::ExpectationNotMetError.new "message"
        set_backtrace error
        @reporter.add_spec "spec", error, "spec"
        @reporter.dump
        assert_match(/\nF\n\n1\)\nExpectationNotMetError in 'context spec'\nmessage\n\/a\/b\/c\/d\/e.rb:34:in `spec'\n\nFinished in /, @io.string)
      end
      
      def test_should_end_with_line_break
        error = Spec::Api::ExpectationNotMetError.new "message"
        set_backtrace error
        @reporter.add_spec "spec", error, "spec"
        @reporter.dump
        assert_match(/\n\z/, @io.string)
      end
    
      def test_should_include_informational_header
        error = Spec::Api::ExpectationNotMetError.new "message"
        set_backtrace error
        @reporter.add_spec "spec", error, "spec"
        @reporter.dump
        assert_match(/^ExpectationNotMetError in 'context spec'/, @io.string)
      end
    
      def test_should_include_context_and_spec_name_in_backtrace_if_error_in_spec
        error = RuntimeError.new "message"
        set_backtrace error
        @reporter.add_spec "spec", error, "spec"
        @reporter.dump
        assert_match(/RuntimeError in 'context spec'/, @io.string)
        assert_match(/:in `spec'/, @io.string)
      end

      def test_should_include_context_and_setup_in_backtrace_if_error_in_setup
        error = RuntimeError.new
        set_backtrace error
        @reporter.add_spec "spec", error, "setup"
        @reporter.dump
        assert_match(/RuntimeError in 'context spec'/, @io.string)
        assert_match(/in `setup'/, @io.string)
      end

      def test_should_include_context_and_teardown_in_backtrace_if_error_in_teardown
        error = RuntimeError.new
        set_backtrace error
        @reporter.add_spec "spec", error, "teardown"
        @reporter.dump
        assert_match(/RuntimeError in 'context spec'/, @io.string)
        assert_match(/in `teardown'/, @io.string)
      end
      
    end
    
    class VerboseFailureDumpTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = Reporter.new(SpecdocFormatter.new(@io, true), true, QuietBacktraceTweaker.new)
        @reporter.add_context "context"
      end

      def set_backtrace error
        error.set_backtrace ["/a/b/c/d/e.rb:34:in `__instance_exec'"]
      end

      def test_spacing_between_sections
        error = Spec::Api::ExpectationNotMetError.new "message"
        set_backtrace error
        @reporter.add_spec "spec", error, "spec"
        @reporter.dump
        assert_match(/\ncontext\n- spec \(FAILED - 1\)\n\n1\)\nExpectationNotMetError in 'context spec'\nmessage\n\/a\/b\/c\/d\/e.rb:34:in `spec'\n\nFinished in /, @io.string)
      end
      
    end
  end 
end