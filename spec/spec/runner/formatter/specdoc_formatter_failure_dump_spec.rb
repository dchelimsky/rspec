require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Runner
module Formatter
context "SpecdocFormatterFailureDump" do
    setup do
        @io = StringIO.new
        @reporter = Reporter.new(SpecdocFormatter.new(@io), QuietBacktraceTweaker.new)
        @reporter.add_context("context")
      
    end
    specify "spacing between sections" do
      
        error=Spec::Expectations::ExpectationNotMetError.new("message")
        set_backtrace(error)
        @reporter.spec_finished("spec", error, "spec")
        @reporter.dump
        @io.string.should_match(/\ncontext\n- spec \(FAILED - 1\)\n\n1\)\nSpec::Expectations::ExpectationNotMetError in 'context spec'\nmessage\n\/a\/b\/c\/d\/e.rb:34:in `spec'\n\nFinished in /)
      
    end
    def set_backtrace  (error)
      error.set_backtrace(["/a/b/c/d/e.rb:34:in `__instance_exec'"])
    end
  
end
end
end
end