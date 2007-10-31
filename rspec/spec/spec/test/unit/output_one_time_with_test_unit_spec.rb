require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    describe CommandLine do
      it "should not output twice" do
        dir = File.dirname(__FILE__)
        output =`ruby #{dir}/output_one_time_with_test_unit_fixture_runner.rb`
        output.should include("1 example, 0 failures")
        output.should_not include("0 examples, 0 failures")
      end

      it "when no tests are run, does not output test/unit summary" do
        dir = File.dirname(__FILE__)
        output =`ruby #{dir}/output_one_time_with_test_unit_fixture_runner.rb`
        output.should_not include("Started")
        output.should_not match(/\btests\b/)
        output.should_not include("Loaded suite")
        output.should_not include("assertions")
        output.should_not match(/(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors/)
      end

      it "when tests are run, output test/unit sumary" do
        dir = File.dirname(__FILE__)
        output =`ruby #{dir}/sample_spec_test.rb`
        output.should include("Started")
        output.should match(/\btests\b/)
        output.should include("Loaded suite")
        output.should include("assertions")
        output.should include("1 tests, 1 assertions, 0 failures, 0 errors")
      end
    end
  end
end