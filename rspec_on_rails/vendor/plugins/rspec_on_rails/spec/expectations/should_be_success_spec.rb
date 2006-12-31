require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "Given a controller spec in #{mode} mode, response.should_be_success", :context_type => :controller do
    controller_name :redirect_spec
    if mode == 'integration'
      integrate_views
    end
    
    specify "should pass if response_code is 200" do
      get 'action_with_no_redirect'
      response.should_be_success
    end
    
    specify "should fail if redirect" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should_be_success
      }.should_fail_with "response code should be success (200) but was redirect (302) to http://test.host/redirect_spec/somewhere"
    end
    
    specify "should fail on 404" do
      get 'action_with_no_redirect'
      response.headers['Status'] = '404 Server Error'
      lambda {
        response.should_be_success
      }.should_fail_with "response code should be success (200) but was (404)"
    end
    
    specify "should fail if server error" do
      get 'action_with_no_redirect'
      response.headers['Status'] = '500 Server Error'
      lambda {
        response.should_be_success
      }.should_fail_with "response code should be success (200) but was (500)"
    end
  end
end
    
