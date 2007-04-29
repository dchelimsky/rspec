require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/create" do
  include PeopleHelper
  
  before(:each) do
    @person = mock_model(Person)
    assigns[:people] = [@person]
  end

  it "should display stuff from helper" do
    render "/people/create"
    response.should have_tag('input#person_address')
  end
  
end

