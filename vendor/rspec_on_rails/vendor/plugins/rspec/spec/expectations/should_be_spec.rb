require File.dirname(__FILE__) + '/../spec_helper'

context "Given a 'get' with an empty action and no view in default mode",
  :context_type => :controller do
  controller_name :should_be_spec
  
  setup do
    get 'action_with_nothing_in_body_and_no_corresponding_template'
  end
  
  specify "the response should_be_success" do
    response.should_be_success
  end
end
    

