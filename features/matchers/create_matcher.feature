Feature: custom matcher shortcut

  In order to express my domain clearly in my code examples
  As an RSpec user
  I want to a shortcut for create custom matchers

  Scenario: create a matcher with default messages
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |actual, expected|
        match do
          actual % expected == 0
        end
      end

      describe 9 do
        it {should be_a_multiple_of(3)}
      end

      describe 9 do
        it {should_not be_a_multiple_of(4)}
      end

      # fail intentionally to generate expected output
      describe 9 do
        it {should be_a_multiple_of(4)}
      end

      # fail intentionally to generate expected output
      describe 9 do
        it {should_not be_a_multiple_of(3)}
      end

      """
    When I run it with the spec command --format specdoc
    Then the exit code should be 256

    And the stdout should match "should be a multiple of 3"
    And the stdout should match "should not be a multiple of 4"
    And the stdout should match "should be a multiple of 4 (FAILED - 1)"
    And the stdout should match "should not be a multiple of 3 (FAILED - 2)"

    And the stdout should match "4 examples, 2 failures"
    And the stdout should match "expected 9 to be a multiple of 4"
    And the stdout should match "expected 9 to not be a multiple of 3"
    
  Scenario: override the failure_message_for(:should)
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |actual, expected|
        match do
          actual % expected == 0
        end
        failure_message_for(:should) do
          "expected that #{actual} would be a multiple of #{expected}"
        end
      end
  
      # fail intentionally to generate expected output
      describe 9 do
        it {should be_a_multiple_of(4)}
      end
      """
    When I run it with the spec command
    Then the exit code should be 256
    And the stdout should match "1 example, 1 failure"
    And the stdout should match "expected that 9 would be a multiple of 4"
  
  Scenario: override the failure_message_for(:should_not)
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |actual, expected|
        match do
          actual % expected == 0
        end
        failure_message_for(:should_not) do
          "expected that #{actual} would not be a multiple of #{expected}"
        end
      end
  
      # fail intentionally to generate expected output
      describe 9 do
        it {should_not be_a_multiple_of(3)}
      end
      """
    When I run it with the spec command
    Then the exit code should be 256
    And the stdout should match "1 example, 1 failure"
    And the stdout should match "expected that 9 would not be a multiple of 3"
  
  Scenario: override the description
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |actual, expected|
        match do
          actual % expected == 0
        end
        description do
          "be multiple of #{expected}"
        end
      end

      describe 9 do
        it {should be_a_multiple_of(3)}
      end

      describe 9 do
        it {should_not be_a_multiple_of(4)}
      end
      """
    When I run it with the spec command --format specdoc
    Then the exit code should be 0
    And the stdout should match "2 examples, 0 failures"
    And the stdout should match "should be multiple of 3"
    And the stdout should match "should not be multiple of 4"


  
