require File.dirname(__FILE__) + '/../../spec_helper'

context "/person/list" do
  fixtures :people
  controller_name :person
  
  setup do
    get 'index'
  end

  specify "should display the list of people" do
    response.should_have_tag 'p', :content => 'Find me in app/views/person/list.rhtml'
  end

  specify "should not have any <div> tags" do
    response.should_not_have_tag '<div>'
  end
  
end
