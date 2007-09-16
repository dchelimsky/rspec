require File.dirname(__FILE__) + '/../../spec_helper.rb'

# NOTE - this was initially handled by an explicit matcher, but is now
# handled by a default set of predicate_matchers.

# module Spec
#   module Matchers
#     class Exist
#       def matches? actual
#         @actual = actual
#         @actual.exist?
#       end
#       def failure_message
#         "expected #{@actual.inspect} to exist, but it doesn't."
#       end
#       def negative_failure_message
#         "expected #{@actual.inspect} to not exist, but it does."
#       end
#     end
#     def exist; Exist.new; end
#   end
# end


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
  
class SubstanceTester
  include Spec::Matchers
  def initialize substance
    @substance = substance
  end
  def should_exist
    @substance.should exist
  end
end

describe "should exist" do
  before(:each) do
    @real = Substance.new true, 'something real'
    @imaginary = Substance.new false, 'something imaginary'
  end
  
  it "should pass if target exists" do
    @real.should exist
  end
  
  it "should fail if target does not exist" do
    lambda { @imaginary.should exist }.
      should fail
  end
end

describe "should exist, outside of a behavior" do
  before(:each) do
    @real = Substance.new true, 'something real'
    @imaginary = Substance.new false, 'something imaginary'
  end
  it "should pass if target exists" do
    pending("need to either find a way to include stock predicate matchers in Spec::Matchers or add Bret's Exist matcher") do
      real_tester = SubstanceTester.new @real
      real_tester.should_exist
    end
  end
end
