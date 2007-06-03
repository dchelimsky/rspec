require File.dirname(__FILE__) + '/../spec_helper'

describe PeopleHelper do
  
  it "should say hello" do
    say_hello.should == "Hello"
  end
  
  it "should provide person address text field tag" do
    @person = mock_model(Person)
    @person.stub!(:address).and_return("The moon")
    person_address_text_field.should == "<input id=\"person_address\" name=\"person[address]\" size=\"30\" type=\"text\" value=\"The moon\" />"
  end
end
