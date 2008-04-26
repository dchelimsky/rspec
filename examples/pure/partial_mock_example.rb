require File.dirname(__FILE__) + '/spec_helper'

class MockableClass
  def self.find id
    return :original_return
  end

  def public_method
    private_method
    protected_method
  end

protected

  def protected_method; end

private

  def private_method; end

end

describe "A partial mock" do

  it "should work at the class level" do
    MockableClass.should_receive(:find).with(1).and_return {:stub_return}
    MockableClass.find(1).should equal(:stub_return)
  end

  it "should revert to the original after each spec" do
    MockableClass.find(1).should equal(:original_return)
  end

  it "can be mocked w/ ordering" do
    MockableClass.should_receive(:msg_1).ordered
    MockableClass.should_receive(:msg_2).ordered
    MockableClass.should_receive(:msg_3).ordered
    MockableClass.msg_1
    MockableClass.msg_2
    MockableClass.msg_3
  end

  it 'should make public proxies for public methods' do
    object = MockableClass.new
    object.should_receive(:public_method)
    object.public_methods.include?('public_method').should == true
    object.public_method
  end

  it 'should make private proxies for private methods' do
    object = MockableClass.new
    object.should_receive(:private_method)
    object.private_methods.include?('private_method').should == true
    object.public_method
  end

  it 'should make protected proxies for protected methods' do
    object = MockableClass.new
    object.should_receive(:protected_method)
    object.protected_methods.include?('protected_method').should == true
    object.public_method
  end

end
