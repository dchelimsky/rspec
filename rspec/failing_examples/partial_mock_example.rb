require File.dirname(__FILE__) + '/spec_helper'

class MockableClass
  def self.find id
    return :original_return
  end
end

context "A partial mock" do

  specify "should work at the class level (but fail here due to the type mismatch)" do
    MockableClass.should_receive(:find).with(1).and_return {:stub_return}
    MockableClass.find("1").should_equal :stub_return
  end

  specify "should revert to the original after each spec" do
    MockableClass.find(1).should_equal :original_return
  end

end
