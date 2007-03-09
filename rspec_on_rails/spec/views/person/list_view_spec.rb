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

    response.should have_tag('ul') do
      with_tag('li', 'Name: Smith')
      with_tag('li', 'Name: Jones')
    end
  end

  specify "should have a <div> tag with :id => 'a" do
    render "/person/list"
    response.should have_tag('div#a')
  end

  specify "should have a <hr> tag with :id => 'spacer" do
    render "/person/list"
    response.should have_tag('hr#spacer')
  end
end
