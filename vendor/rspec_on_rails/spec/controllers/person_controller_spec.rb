require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  fixtures :people
  controller_name :person

  specify "should be a PersonController" do
    controller.should.be.an.instance.of PersonController
  end

  specify "should accept GET to index" do
    get 'index'
    response.should.be.success
    assigns('people').should_equal [people(:lachie)]
  end
end
