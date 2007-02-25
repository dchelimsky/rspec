require File.dirname(__FILE__) + '/../../spec_helper'

class Animal < ActiveRecord::Base
  validates_presence_of :age, :name
  validates_numericality_of :age
end

context "receiver.should have(n).errors_on(:attribute)" do
  setup do
    @animal = Animal.new
  end

  specify "should fail if the expected error count is more than the actual count" do
    lambda {
      @animal.should have(7).errors_on(:age)
    }.should_fail_with "expected 7 errors on :age, got 2"
  end

  specify "should fail if the expected error count is less than the actual count" do
    lambda {
      @animal.should have(1).error_on(:age)
    }.should_fail_with "expected 1 error on :age, got 2"
  end

  specify "should pass if the expected error count matches the actual (plural form)" do
    lambda {@animal.should have(2).errors_on(:age)}.should_pass
  end

  specify "should pass if the expected error count matches the actual (singular form)" do
    lambda {@animal.should have(1).error_on(:name)}.should_pass
  end

  specify "should re-validate the model each time it is run" do
    lambda {@animal.should have(1).error_on(:name)}.should_pass
    @animal.name = 'Bobby Joe'
    lambda {@animal.should have(0).errors_on(:name)}.should_pass
  end
end
