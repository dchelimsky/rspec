Feature: define wrapped matcher

  In order to reuse existing assertions
  As an RSpec user
  I want to define matchers that wrap test/unit assertions

  Scenario: one additional method
    Given a file named "wrapped_assertion_spec.rb" with:
      """
      require 'test/unit/assertions'
      Spec::Matchers.define :have_button do
        extend Test::Unit::Assertions
        match do |markup|
          wrapped_assertion do
            assert_equal "<button>Label</button>", markup
          end
        end
      end

      describe "some markup" do
        it "has a button" do
          "<button>Label</button>".should have_button
        end
      end

      describe "some other markup" do
        it "has a button" do
          "<span>Label</span>".should_not have_button
        end
      end

      describe "yet more markup" do
        it "has a button" do
          # this will intentionally fail
          "<span>Label</span>".should have_button
        end
      end
      """
    When I run "spec wrapped_assertion_spec.rb --format specdoc"
    Then the stdout should include "3 examples, 1 failure"
