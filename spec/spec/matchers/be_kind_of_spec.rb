require File.dirname(__FILE__) + '/../../spec_helper.rb'
require File.dirname(__FILE__) + '/../../../lib/spec/matchers/be_kind_of'

describe Spec::Matchers::BeKindOf do
  it "should have description" do
    Spec::Matchers::BeKindOf.new(Class).should respond_to(:description)
  end

  it "should pass if object is kind of given class" do
    "foo".should be_kind_of(String)
  end

  it "should fail with failure message unless object is kind of given class" do
    lambda { "foo".should be_kind_of(Array) }.should fail_with("expected to be kind of Array, but actually was kind of String")
  end

  it "should fail with negative failure message if object is not kind of given class" do
    lambda { "foo".should_not be_kind_of(String) }.should fail_with("expected not to be kind of String, but was")
  end
end
