Feature: matcher

  Scenario: create matcher
    Given the following spec:
      """
      Spec::Matchers.create :look_like do |expected, actual|
        match do
          actual == expected
        end
      end
      describe "appearances" do
        it "should be similar" do
          5.should look_like(5)
        end
      end
      describe "different appearances" do
        it "should be similar" do
          4.should look_like(5)
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 256
    And the stdout should match "2 examples, 1 failure"
    And the stdout should match "expected 4 to look like 5"
    
