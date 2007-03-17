require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    context "Reporter" do
      setup do
        @io = StringIO.new
        disable_auto_verification_of_mocks
        @backtrace_tweaker = mock("backtrace tweaker")
        @formatter = mock("formatter")
        @reporter = Reporter.new(@formatter, @backtrace_tweaker)
      end
      specify "should account for context in stats" do
        @formatter.should_receive(:add_behaviour).with("context", true)
        @reporter.add_behaviour("context")
      end
      specify "should account for spec and error in stats for pass" do
        @formatter.should_receive(:add_behaviour)
        @formatter.should_receive(:spec_started).with("spec")
        @formatter.should_receive(:spec_failed).with("spec", 1, failure)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_failure).with(1, :anything)
        @formatter.should_receive(:dump_summary).with(:anything, 1, 1)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec", RuntimeError.new)
        @reporter.dump
      end

      specify "should account for spec in stats for pass" do
        @formatter.should_receive(:spec_started)
        @formatter.should_receive(:spec_passed)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 1, 0)
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec")
        @reporter.dump
      end

      specify "should delegate to backtrace tweaker" do
        @formatter.should_receive(:add_behaviour)
        @formatter.should_receive(:spec_failed)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_behaviour("context")
        @reporter.spec_finished("spec", RuntimeError.new)
        @backtrace_tweaker.__verify
      end

      specify "should handle multiple contexts with same name" do
        @formatter.should_receive(:add_behaviour).exactly(3).times
        @formatter.should_receive(:spec_started).exactly(3).times
        @formatter.should_receive(:spec_passed).exactly(3).times
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 3, 0)
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec 1")
        @reporter.spec_finished("spec 1")
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec 2")
        @reporter.spec_finished("spec 2")
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec 3")
        @reporter.spec_finished("spec 3")
        @reporter.dump
      end

      specify "should handle multiple specs same name" do
        error=RuntimeError.new
        @formatter.should_receive(:add_behaviour).exactly(2).times
        @formatter.should_receive(:spec_started).with("spec").exactly(4).times
        @formatter.should_receive(:spec_passed).with("spec").exactly(2).times
        @formatter.should_receive(:spec_failed).with("spec", 1, failure)
        @formatter.should_receive(:spec_failed).with("spec", 2, failure)
        @formatter.should_receive(:dump_failure).exactly(2).times
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 4, 2)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec")
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec", error)
        @reporter.add_behaviour("context")
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec")
        @reporter.spec_started("spec")
        @reporter.spec_finished("spec", error)
        @reporter.dump
      end
      
      specify "should push context to formatter" do
        @formatter.should_receive(:add_behaviour).never
        @reporter.add_behaviour("context")
      end
      
      specify "should push stats to reporter even with no data" do
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 0, 0)
        @reporter.dump
      end
      
      specify "should push time to reporter" do
        @formatter.should_receive(:start).with(5)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary) do |time, a, b|
          time.to_s.should match(/[0-9].[0-9|e|-]+/)
        end
        @reporter.start(5)
        @reporter.end
        @reporter.dump
      end
      
      def failure
        Mocks::DuckTypeArgConstraint.new(:header, :exception)
      end
  
    end
  end
end