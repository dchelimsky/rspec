require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "redirect_to behaviour", :context_type => :controller do
    if mode == 'integration'
      integrate_views
    end
    controller_name :redirect_spec
  
    specify "redirected to another action" do
      get 'action_with_redirect_to_somewhere'
      response.should redirect_to(:action => 'somewhere')
    end
    
    specify "redirected to another controller and action" do
      get 'action_with_redirect_to_other_somewhere'
      response.should redirect_to(:controller => 'other', :action => 'somewhere')
    end
    
    specify "redirected to another action (with 'and return')" do
      get 'action_with_redirect_to_somewhere_and_return'
      response.should redirect_to(:action => 'somewhere')
    end
  
    specify "redirected to correct path with leading /" do
      get 'action_with_redirect_to_somewhere'
      response.should redirect_to('/redirect_spec/somewhere')
    end
    
    specify "redirected to correct path without leading /" do
      get 'action_with_redirect_to_somewhere'
      response.should redirect_to('redirect_spec/somewhere')
    end
    
    specify "redirected to correct internal URL" do
      get 'action_with_redirect_to_somewhere'
      response.should redirect_to("http://test.host/redirect_spec/somewhere")
    end
  
    specify "redirected to correct external URL" do
      get 'action_with_redirect_to_rspec_site'
      response.should redirect_to("http://rspec.rubyforge.org")
    end
  
    specify "redirected :back" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      get 'action_with_redirect_back'
      response.should redirect_to(:back)
    end
  
    specify "redirected :back and should_redirect_to URL matches" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      get 'action_with_redirect_back'
      response.should redirect_to("http://test.host/previous/page")
    end
  end
  
  context "Given a controller spec in #{mode} mode", :context_type => :controller do
    if mode == 'integration'
      integrate_views
    end
    controller_name :redirect_spec
  
    specify "an action that redirects should not result in an error if no should_redirect_to expectation is called" do
      get 'action_with_redirect_to_somewhere'
    end
  end
  
  context "Given a controller spec in #{mode} mode, should_redirect_to should fail when", :context_type => :controller do
    if mode == 'integration'
      integrate_views
    end
    controller_name :redirect_spec
    
    specify "redirected to wrong action" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should redirect_to(:action => 'somewhere_else')
      }.should_fail_with "expected redirect to {:action=>\"somewhere_else\"}, got redirect to \"http://test.host/redirect_spec/somewhere\""
    end
    
    specify "redirected to incorrect path with leading /" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should redirect_to('/redirect_spec/somewhere_else')
      }.should_fail_with 'expected redirect to "/redirect_spec/somewhere_else", got redirect to "http://test.host/redirect_spec/somewhere"'
    end
  
    specify "redirected to incorrect path without leading /" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should redirect_to('redirect_spec/somewhere_else')
      }.should_fail_with 'expected redirect to "redirect_spec/somewhere_else", got redirect to "http://test.host/redirect_spec/somewhere"'
    end
  
    specify "redirected to incorrect internal URL (based on the action)" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should redirect_to("http://test.host/redirect_spec/somewhere_else")
      }.should_fail_with 'expected redirect to "http://test.host/redirect_spec/somewhere_else", got redirect to "http://test.host/redirect_spec/somewhere"'
    end
    
    specify "redirected to wrong external URL" do
      get 'action_with_redirect_to_rspec_site'
      lambda {
        response.should redirect_to("http://test.unit.rubyforge.org")
      }.should_fail_with 'expected redirect to "http://test.unit.rubyforge.org", got redirect to "http://rspec.rubyforge.org"'
    end
  
    specify "redirected to incorrect internal URL (based on the directory path)" do
      get 'action_with_redirect_to_somewhere'
      lambda {
        response.should redirect_to("http://test.host/non_existent_controller/somewhere")
      }.should_fail_with 'expected redirect to "http://test.host/non_existent_controller/somewhere", got redirect to "http://test.host/redirect_spec/somewhere"'
    end
  
    specify "expected redirect :back, but redirected to a new URL" do
      get 'action_with_no_redirect'
      lambda {
        response.should redirect_to(:back)
      }.should_fail_with 'expected redirect to :back, got no redirect'
    end
  
    specify "no redirect at all" do
      get 'action_with_no_redirect'
      lambda {
        response.should redirect_to(:action => 'nowhere')
      }.should_fail_with "expected redirect to {:action=>\"nowhere\"}, got no redirect"
    end
  
  end
end
