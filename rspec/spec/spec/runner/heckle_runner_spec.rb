require File.dirname(__FILE__) + '/../../spec_helper.rb'
require 'spec/runner/heckle_runner'

context "HeckleRunner" do
  specify "should load all classes in module" do
    heckle = mock("heckle")
    heckle.should_receive(:validate).at_least(7).times
    
    heckle_class = mock("heckle_class")
    heckle_class.should_receive(:new).at_least(7).and_return(heckle)
    heckle_runner = Spec::Runner::HeckleRunner.new("Spec::Runner::Formatter", heckle_class)
    
    context_runner = mock("context_runner")
    heckle_runner.heckle_with(context_runner)
  end
end
