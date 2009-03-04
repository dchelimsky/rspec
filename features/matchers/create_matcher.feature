Feature: custom matcher shortcut

  In order to express my domain clearly in my code examples
  As an RSpec user
  I want a shortcut for create custom matchers

  Scenario: creating a matcher with default messages
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |expected|
        match do |actual|
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
    And the stdout should match "expected 9 not to be a multiple of 3"
    
  Scenario: overriding the failure_message_for_should
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |expected|
        match do |actual|
          actual % expected == 0
        end
        failure_message_for_should do |actual|
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
  
  Scenario: overriding the failure_message_for_should_not
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |expected|
        match do |actual|
          actual % expected == 0
        end
        failure_message_for_should_not do |actual|
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
  
  Scenario: overriding the description
    Given the following spec:
      """
      Spec::Matchers.create :be_a_multiple_of do |expected|
        match do |actual|
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
