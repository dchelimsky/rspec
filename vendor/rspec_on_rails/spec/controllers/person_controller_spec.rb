require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  fixtures :people
  controller_name :person

  specify "should be a PersonController" do
    controller.should.be.an.instance.of PersonController
  end

  specify "should find all people on GET to index" do
    get 'index'
    response.should.be.success
    assigns('people').should_equal [people(:lachie)]
  end

  specify "should create unsaved person record on GET to create" do
    get 'create'
    response.should.be.success
    assigns('person').should_be_new_record
  end
end
