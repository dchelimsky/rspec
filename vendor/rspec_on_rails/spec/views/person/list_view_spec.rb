require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/list" do
  
  setup do
    @person = mock("person")
    @person.stub!(:name).and_return("Joe")
    assigns[:people] = [@person]
  end
  
  specify "should display the list of people" do
    @person.should_receive(:name).and_return("Smith")
    render "/person/list"
    response.should_have_tag 'li', :content => 'Smith'
  end

  specify "should have a <div> tag with :id => 'a" do
    render "/person/list"
    response.should_have_tag 'div', :attributes =>{:id => "a"}
  end
  
end
