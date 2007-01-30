require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/list" do

  setup do
    @smith = mock_model(Person)
    @jones = mock_model(Person)
    @smith.stub!(:name).and_return("Joe")
    @jones.stub!(:name).and_return("Joe")
    assigns[:people] = [@smith, @jones]
  end

  specify "should display the list of people" do
    @smith.should_receive(:name).exactly(3).times.and_return("Smith")
    @jones.should_receive(:name).exactly(3).times.and_return("Jones")

    render "/person/list"

    response.should_have_tag 'li', :content => 'Name: Smith'
    response.should_have_tag 'li', :content => 'Name: Jones'
  end

  specify "should have a <div> tag with :id => 'a" do
    render "/person/list"
    response.should_have_tag 'div', :attributes =>{:id => "a"}
  end

  specify "should have a <hr> tag with :id => 'spacer" do
    render "/person/list"
    response.should_have_tag 'hr', :attributes => {:id => "spacer"}
  end
end
