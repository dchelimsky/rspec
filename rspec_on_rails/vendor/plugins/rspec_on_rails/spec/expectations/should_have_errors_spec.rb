require File.dirname(__FILE__) + '/../spec_helper'

class Animal < ActiveRecord::Base
  validates_presence_of :age, :name
  validates_numericality_of :age
end

context "receiver.should_have(n).errors_on(:attribute)" do
  setup do
    @animal = Animal.new
  end

  specify "should fail if the expected error count does not match the actual" do
    lambda {
      @animal.should_have(7).errors_on(:age)
    }.should_fail_with /Animal should have 7 errors on :age \(has 2\)/
  end

  specify "should pass if the expected error count matches the actual (plural form)" do
    lambda {@animal.should_have(2).errors_on(:age)}.should_pass
  end

  specify "should pass if the expected error count matches the actual (singular form)" do
    lambda {@animal.should_have(1).error_on(:name)}.should_pass
  end

  specify "should re-validate the model each time it is run" do
    lambda {@animal.should_have(1).error_on(:name)}.should_pass
    @animal.name = 'Bobby Joe'
    lambda {@animal.should_have(0).errors_on(:name)}.should_pass
  end
end
