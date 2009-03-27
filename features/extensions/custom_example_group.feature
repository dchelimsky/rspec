Feature: custom example group

  Scenario: simple custom example group
    Given the following spec:
    """
    class CustomGroup < Spec::ExampleGroup
    end
    
    Spec::Example::ExampleGroupFactory.default(CustomGroup)
    
    describe "setting a default example group base class" do
      it "should use that class by default" do
        CustomGroup.should === self
      end
    end
    """
    When I run it with the spec command
    Then the stdout should match "1 example, 0 failures"
    