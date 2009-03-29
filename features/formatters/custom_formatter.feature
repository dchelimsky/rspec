Feature: custom formatters

  In order to format output/reporting to my particular needs
  As an RSpec user
  I want to create my own custom output formatters

  Scenario: specdoc format
    Given the following spec:
      """
      require 'spec/runner/formatter/base_formatter'
      class CustomFormatter < Spec::Runner::Formatter::BaseFormatter
        def example_started(proxy)
          where << "example: " << proxy.description
        end
      end
      
      describe "my group" do
        specify "my example" do
        end
      end
      """
    When I run it with the spec command --format CustomFormatter
    Then the exit code should be 0
    And the stdout should match "example: my example"
  
  
  
  
