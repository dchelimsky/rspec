require File.dirname(__FILE__) + '/../spec_helper'

context PeopleHelper do
  helper_name :people
  
  specify "should say hello" do
    say_hello.should_eql "Hello"
  end
  
  specify "tag helper" do
    @person = mock("person")
    @person.stub!(:address).and_return("The moon")
    person_address_text_field.should_eql "<input id=\"person_address\" name=\"person[address]\" size=\"30\" type=\"text\" value=\"The moon\" />"
  end
end