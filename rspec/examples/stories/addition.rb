require File.join(File.dirname(__FILE__), "helper")
require File.join(File.dirname(__FILE__), "adder")

addition_steps = Spec::Story::StepMatchers.new do |add|
  add.given("an addend of $addend") do |addend|
    @adder ||= Adder.new
    @adder << addend.to_i
  end
  add.when("the addends are added") { @sum = @adder.sum }
  add.then("the sum should be $sum") {|sum| @sum.should == sum.to_i }
end

celebration_steps = Spec::Story::StepMatchers.new do |add|
  add.then("the corks should be popped") {}
end

runner = Spec::Story::PlainTextStoryRunner.new File.expand_path(__FILE__).gsub(".rb","")
runner.step_matchers << addition_steps
runner.step_matchers << celebration_steps
runner.run
