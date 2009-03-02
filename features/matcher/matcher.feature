Feature: custom matcher shortcut

  In order to express my domain clearly in my code examples
  As an RSpec user
  I want to a shortcut for create custom matchers

  Scenario: create matcher
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |actual, expected|
        match do
          actual % expected == 0
        end
      end
      describe "9" do
        it "should be a multiple of 3" do
          9.should be_a_multiple_of(3)
        end
      end
      describe "9" do
        it "should be a multiple of 4" do
          # fail intentionally to generate expected output
          9.should be_a_multiple_of(4)
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 256
    And the stdout should match "2 examples, 1 failure"
    And the stdout should match "expected 9 to be a multiple of 4"
    
