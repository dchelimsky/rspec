Feature: run specific examples by line number

  In order to run a single example from command line
  RSpec allows you to specify the line number of the example(s) to run

  Scenario: --line syntax on single example
    Given the following spec:
      """
      describe "an example" do
        it "has not yet been implemented"
        it "has been implemented" do
          true
        end
      end
      """
    When I run it with the spec command --line 2
    Then the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "current_example.rb:2"

  Scenario: colon line syntax on single example
    Given the following spec:
      """
      describe "an example" do
        it "has not yet been implemented"
        it "has been implemented" do
          true
        end
      end
      """
    When I run it with the spec command:2
    Then the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "current_example.rb:2"
