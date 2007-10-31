require File.dirname(__FILE__) + '/../spec_helper'

describe PeopleHelper do
  it "should say hello" do
    say_hello.should == "Hello"
  end
  
  it "should provide person address text field tag" do
    @person = Person.new
    @person.address = "The moon"
    person_address_text_field.should == "<input id=\"person_address\" name=\"person[address]\" size=\"30\" type=\"text\" value=\"The moon\" />"
  end

  it "does not collide with PrototypeHelper" do
    @person = Person.new
    @person.address = "The moon"
    person_address_input_field.should == "<textarea cols=\"40\" id=\"person_address\" name=\"person[address]\" rows=\"20\">The moon</textarea>"
    proc do
      i_dont_exist
    end.should raise_error(NameError)
  end
end
