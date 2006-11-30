require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/list" do
  
  setup do
    @smith = mock("Smith")
    @jones = mock("Jones")
    @smith.stub!(:name).and_return("Joe")
    @jones.stub!(:name).and_return("Joe")
    assigns[:people] = [@smith, @jones]
  end
  
  specify "should display the list of people" do
    @smith.should_receive(:name).twice.and_return("Smith")
    @jones.should_receive(:name).twice.and_return("Jones")

    render "/person/list"
    
    response.should_have_tag 'li', :content => 'Name: Smith'
    response.should_have_tag 'li', :content => 'Name: Jones'
  end

  specify "should have a <div> tag with :id => 'a" do
    render "/person/list"
    response.should_have_tag 'div', :attributes =>{:id => "a"}
  end
  
end
