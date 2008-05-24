require File.dirname(__FILE__) + "/any_instance/method_stubber"
require File.dirname(__FILE__) + "/any_instance/any_instance_proxy"
require File.dirname(__FILE__) + "/any_instance/methods"

module Spec
  module Mocks
    # An addition to rspec's mock/stub library which
    # will allow stubs to be included to all instances of a class. 
    #
    # MyClass.any_instance.stub!(:foo).and_return :my_value
    #
    # MyClass.new.foo #=> :my_value
    # MyClass.new.foo #=> :my_value
    #
    # 
    # Regular instance level stubs will still work as usual,
    # overriding the behavior of stubbing all instances of a class:
    #
    # MyClass.any_instance.stub!(:my_method).and_return :foo
    # instance = MyClass.new
    # instance.stub!(:my_method).and_return :bar
    # instance.my_method  #=> :bar
    #
    module AnyInstance
    end
  end
end
