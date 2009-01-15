Feature: mock with rr

  As an RSpec user who prefers rr
  I want to be able to use rr without rspec mocks interfering

  Scenario: Mock with rr
    Given the following spec:
      """
      Spec::Runner.configure do |config|
        config.mock_with :rr
      end

      describe "plugging in rr" do
        it "allows rr to be used" do
          target = Object.new
          mock(target).foo
          target.foo
        end

        it "does not include rspec mocks" do
          Spec.const_defined?(:Mocks).should be_false
        end
      end
      """
    When I run it with the spec command
    Then the exit code should be 0
    And the stdout should match "2 examples, 0 failures"