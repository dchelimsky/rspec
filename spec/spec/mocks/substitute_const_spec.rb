require 'spec/spec_helper'

Spec::Matchers.define :run_successfully_with do |options|
  match do |group|
    group.run(options)
  end
  
  failure_message_for_should do |group|
    %Q|expected example group "#{group.description}" to run successfully|
  end
end

describe "#[mock|restore]_class" do
  class ClassToBeRedefined
    def self.class_method
      :original
    end
  end
  
  class AnotherClassToBeRedefined
    def self.class_method
      :original2
    end
  end
  
  describe "mock_class" do
    it "creates a double" do
      mock_class(ClassToBeRedefined)
      ClassToBeRedefined.should be_a(Spec::Mocks::Mock)
    end
  end
  
  with_sandboxed_options do
    describe "restore_class" do
      it "restores the orig const" do
        original_const = ClassToBeRedefined
        mock_class(ClassToBeRedefined)
        restore_class(ClassToBeRedefined)
        ClassToBeRedefined.should == original_const
      end
    
      it "happens automatically after each example" do
        group = Class.new(Spec::Example::ExampleGroupDouble)
        first_example = group.example do
          mock_class(ClassToBeRedefined)
        end
        second_example = group.example do
          ClassToBeRedefined.should be_a(Class)
        end
        group.should run_successfully_with(options)
      end
    end
  end
  
  describe "acceptance tests" do
    it "our acceptance test" do
      mock_class(ClassToBeRedefined).stub(:class_method).and_return :stubbed
      ClassToBeRedefined.class_method.should == :stubbed
      restore_class(ClassToBeRedefined)
      ClassToBeRedefined.class_method.should == :original
    end
    
    it "handles multiple constants" do
      mock_class(ClassToBeRedefined).stub(:class_method).and_return :stubbed
      mock_class(AnotherClassToBeRedefined).stub(:class_method).and_return :super_stubbed
      ClassToBeRedefined.class_method.should == :stubbed
      AnotherClassToBeRedefined.class_method.should == :super_stubbed
      restore_class(ClassToBeRedefined)
      restore_class(AnotherClassToBeRedefined)
      ClassToBeRedefined.class_method.should == :original
      AnotherClassToBeRedefined.class_method.should == :original2
    end
  end  
  
  it "scoped in module"
end