require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should_have_key" do
  specify "should pass when key is present" do
    lambda do
      {"a" => 1}.should_have_key("a")
    end.should_not_raise
  end

  specify "should fail when key is not present" do
    lambda do
      {"a" => 1}.should_have_key("b")
    end.should_fail_with '<{"a"=>1}> should have key: "b"'
  end
end
