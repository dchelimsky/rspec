require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper
      context "should_include" do
        setup do
          @dummy = "dummy"
          @equal_dummy = "dummy"
          @another_dummy = "another_dummy"
          @nil_var = nil
        end
    
        specify "should have key should not raise when hash inclusion is present" do
          lambda do
            {"a" => 1}.should_have_key("a")
          end.should_not_raise
        end

        specify "should have key should raise when hash inclusion is not present" do
          lambda do
            {"a" => 1}.should_have_key("b")
          end.should_fail_with '<{"a"=>1}> should have key: "b"'
        end

        specify "should not have key should not raise when hash inclusion is not present" do
          lambda do
            {"a" => 1}.should_not_have_key("b")
          end.should_not_raise
        end
    
        specify "should not have key should raise when hash inclusion is present" do
          lambda do
            {"a" => 1}.should_not_have_key("a")
          end.should_fail_with '<{"a"=>1}> should not have key: "a"'
        end
    
        specify "should include should raise when array inclusion is missing" do
          lambda do
            [1, 2, 3].should_include(5)
          end.should_fail
        end
    
        specify "should include should raise when enumerable inclusion is missing" do
          lambda do
            IO.constants.should_include("BLAH")
          end.should_fail
        end
    
        specify "should include should raise when hash inclusion is missing" do
          lambda do
            {"a" => 1}.should_include("b")
          end.should_fail
        end
    
        specify "should include should raise when string inclusion is missing" do
          lambda do
            @dummy.should_include("abc")
          end.should_fail
        end
    
        specify "should include shouldnt raise when array inclusion is present" do
          lambda do
            [1, 2, 3].should_include(2)
          end.should_not_raise
        end
    
        specify "should include shouldnt raise when enumerable inclusion is present" do
          lambda do
            IO.constants.should_include("SEEK_SET")
          end.should_not_raise
        end
    
        specify "should include shouldnt raise when hash inclusion is present" do
          lambda do
            {"a" => 1}.should_include("a")
          end.should_not_raise
        end
    
        specify "should include shouldnt raise when string inclusion is present" do
          lambda do
            @dummy.should_include("mm")
          end.should_not_raise
        end
    
        specify "should not include should raise when array inclusion is present" do
          lambda do
            [1, 2, 3].should_not_include(2)
          end.should_fail
        end
    
        specify "should not include should raise when enumerable inclusion is missing" do
          lambda do
            IO.constants.should_not_include("SEEK_SET")
          end.should_fail
        end
    
        specify "should not include should raise when hash inclusion is present" do
          lambda do
            {"a" => 1}.should_not_include("a")
          end.should_fail
        end
    
        specify "should not include should raise when string inclusion is present" do
          lambda do
            @dummy.should_not_include("mm")
          end.should_fail
        end
    
        specify "should not include shouldnt raise when array inclusion is missing" do
          lambda do
            [1, 2, 3].should_not_include(5)
          end.should_not_raise
        end
    
        specify "should not include shouldnt raise when enumerable inclusion is present" do
          lambda do
            IO.constants.should_not_include("BLAH")
          end.should_not_raise
        end
    
        specify "should not include shouldnt raise when hash inclusion is missing" do
          lambda do
            {"a" => 1}.should_not_include("b")
          end.should_not_raise
        end
    
        specify "should not include shouldnt raise when string inclusion is missing" do
          lambda do
            @dummy.should_not_include("abc")
          end.should_not_raise
        end
      end
    end
  end
end