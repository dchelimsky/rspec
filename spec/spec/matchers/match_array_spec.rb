require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "array.should =~ other_array" do
  it "should pass if target contains all items" do
    [1,2,3].should =~ [1,2,3]
  end

  it "should pass if target contains all items out of order" do
    [1,3,2].should =~ [1,2,3]
  end

  it "should fail if target includes extra items" do
    message =  "expected collection contained:  [1, 2, 3]\n"
    message += "actual collection contained:    [1, 2, 3, 4]\n"
    message += "the extra elements were:        [4]\n"

    lambda {
      [1,2,3,4].should =~ [1,2,3]
    }.should fail_with(message)
  end

  it "should fail if target is missing items" do
    message =  "expected collection contained:  [1, 2, 3]\n"
    message += "actual collection contained:    [1, 2]\n"
    message += "the missing elements were:      [3]\n"

    lambda {
      [1,2].should =~ [1,2,3]
    }.should fail_with(message)
  end

  it "should fail if target is missing items and has extra items" do
    message =  "expected collection contained:  [1, 2, 3]\n"
    message += "actual collection contained:    [1, 2, 4]\n"
    message += "the missing elements were:      [3]\n"
    message += "the extra elements were:        [4]\n"

    lambda {
      [1,2,4].should =~ [1,2,3]
    }.should fail_with(message)
  end

  it "should sort items in the error message" do
    message =  "expected collection contained:  [1, 2, 3, 4]\n"
    message += "actual collection contained:    [1, 2, 5, 6]\n"
    message += "the missing elements were:      [3, 4]\n"
    message += "the extra elements were:        [5, 6]\n"

    lambda {
      [6,2,1,5].should =~ [4,1,2,3]
    }.should fail_with(message)
  end

  it "should accurately report extra elements when there are duplicates" do
    message =  "expected collection contained:  [1, 5]\n"
    message += "actual collection contained:    [1, 1, 1, 5]\n"
    message += "the extra elements were:        [1, 1]\n"

    lambda {
      [1,1,1,5].should =~ [1,5]
    }.should fail_with(message)
  end

  it "should accurately report missing elements when there are duplicates" do
    message =  "expected collection contained:  [1, 1, 5]\n"
    message += "actual collection contained:    [1, 5]\n"
    message += "the missing elements were:      [1]\n"

    lambda {
      [1,5].should =~ [1,1,5]
    }.should fail_with(message)
  end

end

describe "should_not [:with, :multiple, :args]" do
  it "should not exist" do
    lambda {
      [1,2,3].should_not =~ [1,2,3]
    }.should fail_with(/Matcher does not support should_not/)
  end
end
