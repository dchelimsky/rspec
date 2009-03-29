Feature: implicit subject

  The first argument to the outermost example group block is
  made available to each example as an implicit subject of
  that example.
  
  Scenario: subject in top level group
    Given the following spec:
      """
      describe Array, "when first created" do
        it "should be empty" do
          subject.should == []
        end
      end
      """
    When I run it with the spec command
    Then the stdout should match "1 example, 0 failures"

  Scenario: subject in a nested group
    Given the following spec:
      """
      describe Array do
        describe "when first created" do
          it "should be empty" do
            subject.should == []
          end
        end
      end
      """
    When I run it with the spec command
    Then the stdout should match "1 example, 0 failures"
