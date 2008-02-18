require File.dirname(__FILE__) + '/../spec_helper'

describe PeopleHelper do
  it "should say hello" do
    helper.say_hello.should == "Hello"
  end
  
  it "should provide person address text field tag" do
    assigns[:person] = Person.new(:address => "The moon")
    helper.person_address_text_field.should == "<input id=\"person_address\" name=\"person[address]\" size=\"30\" type=\"text\" value=\"The moon\" />"
  end
end
