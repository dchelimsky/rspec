require File.dirname(__FILE__) + '/../lib/spec'

context "A consumer of a stub" do

  specify "should be able to stub objects" do
    obj = Object.new
    stub(obj).method(:foobar).with {:return_value}
    obj.foobar.should_equal :return_value
  end

end
require File.dirname(__FILE__) + '/../lib/spec'

context "A consumer of a stub" do

  specify "should be able to stub objects" do
    obj = Object.new
    stub(obj).method(:foobar).with {:return_value}
    obj.foobar.should_equal :return_value
  end

end

class StubbableClass
  def self.find id
    return :original_return
  end
end

context "A stub" do
  specify "should work at the class level" do
    stub(StubbableClass).method(:find).with {:stub_return}
    StubbableClass.find(1).should_equal :stub_return
  end
  
  specify "should revert to the original after each spec" do
    StubbableClass.find(1).should_equal :original_return
  end
end