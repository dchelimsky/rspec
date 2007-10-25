require File.join(File.dirname(__FILE__), "helper")
require File.join(File.dirname(__FILE__), "adder")

# This example demonstrates a few concepts. More info on that coming soon
# run_story do
#   steps_for(:addition) do
#     Then("the corks should be popped") {}
#   end
#   load File.expand_path(__FILE__).gsub(".rb","")
# end
  
run_story do
  steps << steps_for(:addition) do
    Then("the corks should be popped") {}
  end  
  load File.expand_path(__FILE__).gsub(".rb","")
end
#   
#   
# with_steps_for :addition do
#   Then("the corks should be popped") {}
#   run File.expand_path(__FILE__).gsub(".rb","")
# end