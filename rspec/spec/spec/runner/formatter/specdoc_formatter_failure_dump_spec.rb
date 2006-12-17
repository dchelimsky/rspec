require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "SpecdocFormatterFailureDump" do
  setup do
    @io = StringIO.new
    @reporter = Spec::Runner::Reporter.new(Spec::Runner::Formatter::SpecdocFormatter.new(@io), Spec::Runner::QuietBacktraceTweaker.new)
    @reporter.add_context("context")
  end

  specify "spacing between sections" do
    error=Spec::Expectations::ExpectationNotMetError.new("message")
    set_backtrace(error)
    @reporter.spec_finished("spec", error, "spec")
    @reporter.dump
    @io.string.should_match(/\ncontext\n- spec \(FAILED - 1\)\n\n1\)\n'context spec' FAILED\nmessage\n\/a\/b\/c\/d\/e.rb:34:in `some_method'\n\nFinished in /)
  end

  def set_backtrace(error)
    error.set_backtrace(["/a/b/c/d/e.rb:34:in `some_method'"])
  end
  
end
