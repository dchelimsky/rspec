dir = File.dirname(__FILE__)
if $0 == __FILE__
  require "rubygems"
  require "spec"
  require "#{dir}/../../../lib/spec/rails/dsl/ivar_proxy"
else
  require "#{dir}/../../spec_helper"
end

describe "An Ivar Proxy" do
  setup do
    @object = Object.new
    @proxy = Spec::Rails::DSL::IvarProxy.new(@object)
  end

  it "has [] accessor" do
    @proxy['foo'] = 'bar'
    @object.instance_variable_get(:@foo).should == 'bar'
    @proxy['foo'].should == 'bar'
  end

  it "each method iterates through each element like a Hash" do
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

  it "delete method deletes the element of passed in key" do
    @proxy['foo'] = 'bar'
    @proxy.delete('foo').should == 'bar'
    @proxy['foo'].should be_nil
  end

  it "has_key? detects the presence of a key" do
    @proxy['foo'] = 'bar'
    @proxy.has_key?('foo').should == true
    @proxy.has_key?('bar').should == false
  end
end
