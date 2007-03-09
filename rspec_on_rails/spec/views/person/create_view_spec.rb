require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/create" do
  include PersonHelper
  
  setup do
    @person = mock_model(Person)
    assigns[:people] = [@person]
  end

  specify "should display stuff from helper" do
    render "/person/create"
    response.should have_tag('input#person_address')
  end
  
end

