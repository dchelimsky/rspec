class Adder
  def initialize
    @addends = []
  end
  
  def <<(val)
    @addends << val
  end
  
  def sum
    @addends.inject(0) { |sum_so_far, val| sum_so_far + val }
  end
end

$rspec_story_step_matchers = Spec::Story::StepMatchers.new
$rspec_story_step_matchers.create_matcher(:given, "an addend of $addend") do |addend|
  @adder ||= Adder.new
  @adder << addend.to_i
end

$rspec_story_step_matchers.create_matcher(:when, "the addends are added") { @sum = @adder.sum }
$rspec_story_step_matchers.create_matcher(:then, "the sum should be $sum") {|sum| @sum.should == sum.to_i }
$rspec_story_step_matchers.create_matcher(:then, "the corks should be popped") {}
