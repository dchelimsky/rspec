require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe Kernel, "#respond_to" do
  setup do
    @kernel_impersonator = Class.new do
      include Kernel
    end.new
  end
  
  it "should return a Spec::Matchers::RespondTo" do
    @kernel_impersonator.respond_to.should be_an_instance_of(Spec::Matchers::RespondTo)
  end
  
  it "should pass the submitted names to the RespondTo instance" do
    Spec::Matchers::RespondTo.should_receive(:new).with(:a,'b','c?')
    @kernel_impersonator.respond_to(:a,'b','c?')
  end
end
