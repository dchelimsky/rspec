  require File.dirname(__FILE__) + '/../lib/spec'

class MockableClass
  def self.find id
    return :original_return
  end
end

context "A partial mock" do

  specify "should work at the class level" do
    MockableClass.should_receive(:find).with(1).and_return {:stub_return}
    MockableClass.find(1).should_equal :stub_return
  end

  specify "should revert to the original after each spec" do
    MockableClass.find(1).should_equal :original_return
  end

end

context "A pre-existing class" do
  specify "can be mocked" do
    Object.should_receive(:msg).with(:arg).and_return(:value)
    Object.msg(:arg).should_equal(:value)
  end
  
  specify "can be mocked w/ ordering" do
    Object.should_receive(:msg_1).ordered
    Object.should_receive(:msg_2).ordered
    Object.should_receive(:msg_3).ordered
    Object.msg_1
    Object.msg_2
    Object.msg_3
  end
end