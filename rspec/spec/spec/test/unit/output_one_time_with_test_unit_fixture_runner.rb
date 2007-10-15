dir = File.dirname(__FILE__)
require "test/unit"
require "#{dir}/../../../spec_helper"

triggering_double_output = rspec_options
options = Spec::Runner::OptionParser.parse(
  ["#{dir}/output_one_time_with_test_unit_fixture.rb"], $stderr, $stdout
)
Spec::Runner::CommandLine.run(options)
