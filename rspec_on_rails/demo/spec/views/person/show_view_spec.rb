require File.dirname(__FILE__) + '/../../spec_helper'
require 'ostruct'

context "/person/show" do
  
  specify "should display the person's pets" do
    person = mock("person")
    person.should_receive(:pets).and_return([OpenStruct.new(:name => 'Hannibal'), OpenStruct.new(:name => 'Rufus')])

    assigns[:person] = person
    render "/person/show"
    response.should_have_tag 'li', :content => 'Hannibal'
    response.should_have_tag 'li', :content => 'Rufus'
  end

end