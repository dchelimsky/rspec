Feature: pending examples

  RSpec offers three ways to indicate that an example is disabled pending
  some action.
  
  Scenario: pending implementation
    Given the following spec:
      """
      describe "an example" do
        it "has not yet been implemented"
      end
      """
    When I run it with the spec command
    Then the exit code should be 0
    And the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "Not Yet Implemented"
    And the stdout should match "current_example.rb:3"
    
  Scenario: pending implementation with spec/test/unit
    Given the following spec:
      """
      require 'spec/test/unit'
      describe "an example" do
        it "has not yet been implemented"
      end
      """
    When I run it with the spec command
    Then the exit code should be 0
    And the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "Not Yet Implemented"
    And the stdout should match "current_example.rb:4"

  Scenario: pending any arbitary reason, with no block
    Given the following spec:
      """
      describe "an example" do
        it "is implemented but waiting" do
          pending("something else getting finished")
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 0
    And the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "(something else getting finished)"
    And the stdout should match "current_example.rb:4"

  Scenario: pending any arbitary reason, with a block
    Given the following spec:
      """
      describe "an example" do
        it "is implemented but waiting" do
          pending("something else getting finished") do
            raise "this is the failure"
          end
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 0
    And the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "(something else getting finished)"
    And the stdout should match "current_example.rb:4"

  Scenario: pending any arbitary reason, with a block that passes
    Given the following spec:
      """
      describe "an example" do
        it "is implemented but waiting" do
          pending("something else getting finished") do
            true.should be(true)
          end
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 256
    And the stdout should match "1 example, 1 failure"
    And the stdout should match "FIXED"
    And the stdout should match "Expected pending 'something else getting finished' to fail. No Error was raised."
    And the stdout should match "current_example.rb:4"
