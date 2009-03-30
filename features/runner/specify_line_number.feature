Feature: run specific examples by line number

  In order to run a single example from command line
  RSpec allows you to specify the line number of the example(s) to run

  # Note: the line numbers will appear to be offset by 2. This is due to the template
  # provided in the step definitions. (i.e line 3 really == line 1)

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
    When I run it with the spec command --line 3
    Then the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "current_example.rb:3"

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
    When I run it with the spec command:3
    Then the stdout should match "1 example, 0 failures, 1 pending"
    And the stdout should match "current_example.rb:3"
