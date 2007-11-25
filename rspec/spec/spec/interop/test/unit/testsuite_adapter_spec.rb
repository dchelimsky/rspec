require File.dirname(__FILE__) + '/../../../../spec_helper.rb'
require 'spec/interop/test/unit/testsuite_adapter'

describe "TestSuiteAdapter#size" do
  it "should return the number of examples in the example group" do
    group = Class.new(Spec::ExampleGroup) do
      describe("some examples")
      it("bar") {}
      it("baz") {}
    end
    suite = Test::Unit::TestSuiteAdapter.new("foo", group)
    group.send :add_examples, suite
    suite.size.should == 2
  end
end
