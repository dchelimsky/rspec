require File.join(File.dirname(__FILE__), "helper")
require File.join(File.dirname(__FILE__), "adder")

# Init a runner with the file that contains the plain text story
runner = Spec::Story::Runner::PlainTextStoryRunner.new File.expand_path(__FILE__).gsub(".rb","")

# You can append an instance of a subclass of StepMatchers. This one
# can be found in examples/steps/addition_steps.rb
runner.step_matchers << AdditionSteps.new

# And/or you can add steps that are unique to this story right here
runner.step_matchers do |add|
  add.then("the corks should be popped") {}
end

# Run it!
runner.run
