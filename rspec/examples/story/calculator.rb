$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])

require 'spec'

# This is a first cut (very raw) at blockless steps for stories with
# parameters embedded in the strings passed to Given, When and Then
#
# In the long run, $step_matchers will be hidden from view and you'll
# just use a method like create_step_matcher

$step_matchers = Spec::Story::StepMatchers.new

$step_matchers.create_matcher(:given, "an addend of $addend") do |addend|
  @addends ||=[]
  @addends << addend
end

$step_matchers.create_matcher(:when, "they are added") do
  @sum = @addends.inject(0) do |result, addend|
    result + addend.to_i
  end
end

$step_matchers.create_matcher(:then, "the sum should be $sum") do |sum|
  @sum.should == sum.to_i
end

Story "addition", %{
  As an accountant
  I want to add numbers
  So that I can count some beans
} do
  Scenario "2 + 3" do
    Given "an addend of 2"
    And "an addend of 3"
    When "they are added"
    Then "the sum should be 5"
  end
end