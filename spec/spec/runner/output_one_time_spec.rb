require 'spec/spec_helper'

module Spec
  module Runner
    describe CommandLine do
      it "should not output twice" do
        Dir.chdir(".") do
          output =`ruby spec/spec/runner/output_one_time_fixture_runner.rb`
          output.should include("1 example, 0 failures")
          output.should_not include("0 examples, 0 failures")
        end
      end
    end
  end
end