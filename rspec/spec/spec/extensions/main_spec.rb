require File.dirname(__FILE__) + '/../../spec_helper.rb'

class MainObjectImposter
  include Spec::Extensions::Main
end

describe "The main object extended by MainExtensions" do
  before(:each) do
    @main = MainObjectImposter.new
    @original_behaviour_runner = $behaviour_runner
    $behaviour_runner = nil
  end

  after do
    $behaviour_runner = @original_behaviour_runner
  end

  it "should create a BehaviourRunner" do
    @main.send(:behaviour_runner).should be_instance_of(Spec::Runner::BehaviourRunner)
    @main.send(:behaviour_runner).should === $behaviour_runner
  end
  
  specify {@main.should respond_to(:describe)}
  specify {@main.should respond_to(:context)}

  it "should raise when no block given to describe" do
    lambda { @main.describe "foo" }.should raise_error(ArgumentError)
  end

  it "should raise when no description given to describe" do
    lambda { @main.describe do; end }.should raise_error(ArgumentError)
  end
end