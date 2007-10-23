require File.join(File.dirname(__FILE__), "helper")
require File.join(File.dirname(__FILE__), "adder")

# This example demonstrates a few concepts. More info on that coming soon
run_story do |runner|
  runner.step_matchers << AdditionSteps.new do |add|
    add.then("the corks should be popped") {}
  end  
  runner.load File.expand_path(__FILE__).gsub(".rb","")
end
  