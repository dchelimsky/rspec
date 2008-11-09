require File.dirname(__FILE__) + '/spec_helper'

describe "arrays" do
  def contain_same_elements_as(expected)
    simple_matcher "be array with same elements in any order as #{expected.inspect}" do |actual|
      (actual && expected).size == actual.size
    end
  end
  
  describe "can be matched by their contents disregarding order" do
    subject { [1,2,2,3] }
    it { should contain_same_elements_as([1,2,2,3]) }
    it { should contain_same_elements_as([2,3,2,1]) }
  end
  
  it "fail the match with different contents" do
    [1,2,3].should_not contain_same_elements_as([3,2,2,1]) 
    [1,2,2,3].should_not contain_same_elements_as([1,2,3]) 
  end
end