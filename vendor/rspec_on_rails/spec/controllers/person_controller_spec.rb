require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  fixtures :people
  controller_name :person

  specify "should be a PersonController" do
    controller.should_be_instance_of PersonController
  end

  specify "should find all people on GET to index" do
    get 'index'
    response.should_be_success
    assigns('people').should_equal [people(:lachie)]
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
