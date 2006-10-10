require File.dirname(__FILE__) + '/../lib/spec'

context "A consumer of a stub" do
  specify "should be able to stub objects" do
    obj = Object.new
    obj.stub!(:foobar).and_return {:return_value}
    obj.foobar.should_equal :return_value
  end
end

class StubbableClass
  def self.find id
    return :original_return
  end
end

context "A stubbed method on a class" do
  specify "should return the stubbed value" do
    StubbableClass.stub!(:find).and_return {:stub_return}
    StubbableClass.find(1).should_equal :stub_return
  end
  
  specify "should revert to the original method after each spec" do
    StubbableClass.find(1).should_equal :original_return
  end
end

context "A mock" do
  specify "can stub!" do
    mock = mock("stubbing mock")
    mock.stub!(:msg).and_return(:value)
    (1..10).each {mock.msg.should_equal :value}
  end
  
  specify "can stub! and mock" do
    mock = mock("stubbing mock")
    mock.stub!(:stub_message).and_return(:stub_value)
    mock.should_receive(:mock_message).once.and_return(:mock_value)
    (1..10).each {mock.stub_message.should_equal :stub_value}
    mock.mock_message.should_equal :mock_value
    (1..10).each {mock.stub_message.should_equal :stub_value}
  end
  
  # specify "can stub! and mock the same message" do
  #   mock = mock("stubbing mock")
  #   mock.stub!(:msg).and_return(:stub_value)
  #   mock.should_receive(:msg).once.and_return(:mock_value)
  #   mock.msg.should_equal :mock_value
  #   mock.msg.should_equal :stub_value
  #   mock.msg.should_equal :stub_value
  # end
end

    