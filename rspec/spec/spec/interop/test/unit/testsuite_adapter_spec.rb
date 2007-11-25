require File.dirname(__FILE__) + '/../../../../spec_helper.rb'

describe "TestSuiteAdapter" do
  it "should pass" do
    dir = File.dirname(__FILE__)
    output = `ruby #{dir}/testsuite_adapter_spec_with_test_unit.rb`
    raise output unless $?.success?
    raise output if output.include?("FAILED")
    raise output if output.include?("Error")
  end
end