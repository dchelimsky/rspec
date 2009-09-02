Feature: implicit subject

  The first argument to the outermost example group block is
  made available to each example as an implicit subject of
  that example.
  
  Scenario: subject in top level group
    Given a file named "top_level_subject_spec.rb" with:
      """
      describe Array, "when first created" do
        it "should be empty" do
          subject.should == []
        end
      end
      """
    When I run "spec top_level_subject_spec.rb"
    Then the stdout should include "1 example, 0 failures"

  Scenario: subject in a nested group
    Given a file named "nested_subject_spec.rb" with:
      """
      describe Array do
        describe "when first created" do
          it "should be empty" do
            subject.should == []
          end
        end
      end
      """
    When I run "spec nested_subject_spec.rb"
    Then the stdout should include "1 example, 0 failures"

  Scenario: subject with getters
    Given a file named "subject_with_getter_spec.rb" with:
      """
      describe Array do
        describe "when first created" do
          its(:length) { should == 0 }
          its(:size)   { should == 1 }
        end
      end
      """
    When I run "spec subject_with_getter_spec.rb -fn"
    Then the stdout should include "2 examples, 1 failure"
    And  the stdout should include "Array\n  when first created\n    length\n      should == 0\n    size\n      should == 1 (FAILED - 1)"
