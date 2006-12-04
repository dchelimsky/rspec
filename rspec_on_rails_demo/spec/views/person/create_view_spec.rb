require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/create" do
  include PersonHelper
  
  setup do
    @person = mock("person")
    assigns[:people] = [@person]
  end

  specify "should display stuff from helper" do
    render "/person/create"
    response.should_have_tag 'input', :attributes =>{:id => 'person_address'}
  end
  
end

