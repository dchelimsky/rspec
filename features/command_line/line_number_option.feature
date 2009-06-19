Feature: Spec and test together

  As an RSpec user
  I want to run one example identified by the line number
  
  Background:
    Given a file named "example.rb" with:
      """
      describe "a group" do

        it "has a first example" do

        end
        
        it "has a second example" do

        end
        
      end
      """

  Scenario: two examples - first example on declaration line
    When I run "spec example.rb:3 --format nested"
    Then the stdout should match "1 example, 0 failures"
    And the stdout should match "has a first example"
    But the stdout should not match "has a second example"

  Scenario: two examples - first example from line inside declaration
    When I run "spec example.rb:4 --format nested"
    Then the stdout should match "1 example, 0 failures"
    And the stdout should match "has a first example"
    But the stdout should not match "has a second example"

  Scenario: two examples - first example from line below declaration
    When I run "spec example.rb:6 --format nested"
    Then the stdout should match "1 example, 0 failures"
    And the stdout should match "has a first example"
    But the stdout should not match "has a second example"

  Scenario: two examples - second example from line below declaration
    When I run "spec example.rb:7 --format nested"
    Then the stdout should match "1 example, 0 failures"
    And the stdout should match "has a second example"
    But the stdout should not match "has a first example"
