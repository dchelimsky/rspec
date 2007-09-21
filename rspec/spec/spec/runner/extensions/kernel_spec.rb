require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe Kernel, "#behaviour_runner when $behaviour_runner is not set" do
  before do
    @original_behaviour_runner = $behaviour_runner
    $behaviour_runner = nil
  end

  after do
    $behaviour_runner = @original_behaviour_runner
  end

  it "creates a BehaviourRunner" do
    behaviour_runner.should be_instance_of(Spec::Runner::BehaviourRunner)
    behaviour_runner.should === $behaviour_runner
  end
end

describe Kernel, "#behaviour_runner when $behaviour_runner is set" do
  before do
    $behaviour_runner.should_not be_nil
  end

  it "creates a BehaviourRunner" do
    behaviour_runner.should be_instance_of(Spec::Runner::BehaviourRunner)
    behaviour_runner.should === $behaviour_runner
  end
end

describe Kernel, "when extended by rspec" do
  it "should respond to :describe" do
    Object.new.should respond_to(:describe)
    Object.new.should respond_to(:context)
  end
end

describe Kernel, " when creating behaviours with describe" do
  it "should fail when no block given" do
    lambda { describe "foo" }.should raise_error(ArgumentError)
  end

  it "should fail when no description given" do
    lambda { describe do; end }.should raise_error(ArgumentError)
  end
end

describe Kernel, "#respond_to" do
  before(:each) do
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
