require File.dirname(__FILE__) + '/../spec_helper'

context "the PersonHelper" do
  helper_name :person
  
  specify "should say hello" do
    say_hello.should_eql "Hello"
  end
  
  specify "tag helper" do
    person_address_text_field.should_eql "<input id=\"person_address\" name=\"person[address]\" size=\"30\" type=\"text\" />"
  end
end