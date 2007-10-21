require File.join(File.dirname(__FILE__), "helper")
require File.join(File.dirname(__FILE__), "adder")

runner = Spec::Story::PlainTextStoryRunner.new File.expand_path(__FILE__).gsub(".rb","")
runner.step_matchers << AdditionSteps.new
runner.step_matchers << CelebrationSteps.new
runner.run
