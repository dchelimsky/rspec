Feature: define wrapped matcher

  In order to reuse existing assertions
  As an RSpec user
  I want to define matchers that wrap test/unit assertions

  Background:
    Given a file named "have_button.rb" with:
      """
      require 'test/unit/assertions'

      Spec::Matchers.define :have_button do
        extend Test::Unit::Assertions
        match do |markup|
          wrapped_assertion Test::Unit::AssertionFailedError do
            assert_equal "<button>Label</button>", markup
          end
        end
      end
      """
  
  Scenario: passing examples
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
    When I run "spec wrapped_assertion_spec.rb --format specdoc"
    Then the stdout should include "2 examples, 0 failures"

  Scenario: failing examples
    Given a file named "wrapped_assertion_spec.rb" with:
      """
      require 'have_button.rb'

      describe "some markup" do
        it "has a button" do
          # this will intentionally fail
          "<span>Label</span>".should have_button
        end
      end
      
      describe "some other markup" do
        it "does not have a button" do
          # this will intentionally fail
          "<button>Label</button>".should_not have_button
        end
      end
      """
    When I run "spec wrapped_assertion_spec.rb"
    Then the stdout should include "2 examples, 2 failures"
  