dir = File.dirname(__FILE__)
require "#{dir}/../../spec_helper"

context "An Ivar Proxy" do
  setup do
    @object = Object.new
    @proxy = Spec::Rails::DSL::IvarProxy.new(@object)
  end

  specify "has [] accessor" do
    @proxy['foo'] = 'bar'
    @object.instance_variable_get(:@foo).should == 'bar'
    @proxy['foo'].should == 'bar'
  end

  specify "each method iterates through each element like a Hash" do
    values = {
      'foo' => 1,
      'bar' => 2,
      'baz' => 3
    }
    @proxy['foo'] = values['foo']
    @proxy['bar'] = values['bar']
    @proxy['baz'] = values['baz']

    @proxy.each do |key, value|
      key.should == key
      value.should == values[key]
    end
  end

  specify "delete method deletes the element of passed in key" do
    @proxy['foo'] = 'bar'
    @proxy.delete('foo').should == 'bar'
    @proxy['foo'].should be_nil
  end
end
