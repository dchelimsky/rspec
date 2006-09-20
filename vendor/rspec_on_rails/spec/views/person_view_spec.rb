require File.dirname(__FILE__) + '/../spec_helper'

context "Rendering /person" do
  fixtures :people
  controller_name :person
  
  setup do
    get 'index'
  end

  specify "should render 'list'" do
    response.should_render :list
  end

  specify "should not render 'index'" do
    lambda {
      response.should_render :index
    }.should_raise
  end

  specify "should find all people on GET to index" do
    get 'index'
    response.should_be_success
    assigns('people').should_equal [people(:lachie)]
  end

  specify "should display the list of people" do
    should_have_tag 'p', :content => 'Find me in app/views/person/list.rhtml'
  end

  specify "should not have any <div> tags" do
      should_not_have_tag '<div>'
  end

end
