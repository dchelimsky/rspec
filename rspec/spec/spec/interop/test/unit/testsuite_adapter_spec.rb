require File.dirname(__FILE__) + '/../../../../spec_helper.rb'
require 'spec/interop/test/unit/testsuite_adapter'

describe "TestSuiteAdapter#size" do
  it "should the number of examples in the example group" do
    group = Class.new(Spec::ExampleGroup).new("foo")
    adapter = Test::Unit::TestSuiteAdapter.new("name", group)
    adapter << group.class.class_eval do
      it("bar") {}
    end
    adapter << group.class.class_eval do
      it("baz") {}
    end
    adapter.size.should == 2
  end
end
