require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  fixtures :people
  controller_name :person

  specify "should be a PersonController" do
    controller.should_be_instance_of PersonController
  end

  specify "should create an unsaved person record on GET to create" do
    get 'create'
    response.should_be_success
    response.should_not_be_redirect
    assigns('person').should_be_new_record
  end

  specify "should persist a new person and redirect to index on POST to create" do
    post 'create', {:person => {:name => 'Aslak'}}
    Person.find_by_name('Aslak').should_not_be_nil
    response.should_be_redirect
    response.redirect_url.should_equal 'http://test.host/person'
  end
end

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
    response.body.should_have_tag :tag => 'p'
  end
  
  specify "should display the list of people using better api" do
    should_have_tag('p', :content => 'Finds me in app/views/person/list.rhtml')
  end
  
  specify "should not have any <div> tags" do
    lambda {
      response.body.should_have_tag :tag => 'div'
    }.should_raise
  end
  
end  
