require File.dirname(__FILE__) + '/../../spec_helper.rb'

class Substance
  def initialize exists, description
    @exists = exists
    @description = description
  end
  def exist?
    @exists
  end
  def inspect
    @description
  end
end
  
describe "should exist" do
  setup do
    @real = Substance.new true, 'something real'
    @imaginary = Substance.new false, 'something imaginary'
  end
  
  it "should pass if target exists" do
    @real.should exist
  end
  
  it "should fail if target does not exist" do
    lambda { @imaginary.should exist }.
      should fail_with("expected something imaginary to exist, but it doesn't.")
  end
end

describe "should_not exist" do  
  setup do
    @real = Substance.new true, 'something real'
    @imaginary = Substance.new false, 'something imaginary'
  end
  it "should pass if target doesn't exist" do
    @imaginary.should_not exist
  end
  it "should fail if target does exist" do
    lambda { @real.should_not exist }.
      should fail_with("expected something real to not exist, but it does.")
  end
end
    