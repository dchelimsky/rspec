Feature: wrapped assertion raises unexpected error

  In order to know when a wrapped assertion raises an unexpected error
  As an RSpec user
  I want the error to bubble up

  Background:
    Given a file named "have_button.rb" with:
      """
      Spec::Matchers.define :have_button do
        match do |markup|
          wrapped_assertion do
            raise "unexpected error"
          end
        end
      end
      """
  
  Scenario: failing examples
    Given a file named "wrapped_assertion_spec.rb" with:
      """
      require 'have_button.rb'

      describe "some markup" do
        it "has a button" do
          "<button>Label</button>".should have_button
        end
      end
      
      describe "some other markup" do
        it "does not have a button" do
          "<span>Label</span>".should_not have_button
        end
      end
      """
    When I run "spec wrapped_assertion_spec.rb"
    Then the stdout should include "2 examples, 2 failures"
    Then the stdout should include "unexpected error"
  