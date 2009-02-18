require File.dirname(__FILE__) + '/../../spec_helper.rb'
require File.dirname(__FILE__) + '/../../../lib/spec/matchers/be_kind_of'

describe Spec::Matchers::BeKindOf do
  it "passes if object is instance of given class" do
    5.should be_kind_of(Fixnum)
  end

  it "passes if object is instance of subclass of expected class" do
    5.should be_kind_of(Numeric)
  end

  it "fails with failure message unless object is kind of given class" do
    lambda { "foo".should be_kind_of(Array) }.should fail_with(%Q{expected kind of Array, got "foo"})
  end

  it "fails with negative failure message if object is kind of given class" do
    lambda { "foo".should_not be_kind_of(String) }.should fail_with(%Q{expected "foo" not to be a kind of String})
  end

  it "provides a description" do
    Spec::Matchers::BeKindOf.new(Class).description.should == "be kind of Class"
  end
end
