require File.dirname(__FILE__) + '/spec_helper'

['integration', 'isolation'].each do |mode|
  context "Given a controller spec for ControllerIsolationSpecController running in #{mode} mode", :context_type => :controller do
    controller_name :controller_isolation_spec
    integrate_views if mode == 'integration'
  
    specify "session should be the same object as controller session" do
      get 'action_with_template'
      session.should_equal controller.session
    end
  
    specify "session should be the same object before and after the action" do
      session_before = session
      get 'action_with_template'
      session.should_equal session_before
    end
  
    specify "controller.session should NOT be nil before the action" do
      controller.session.should_not_be nil
      get 'action_with_template'
    end
    
    specify "controller.session should NOT be nil after the action" do
      get 'action_with_template'
      controller.session.should_not_be nil
    end
    
    specify "specifying a partial should work" do
      controller.should_render :partial => 'controller_isolation_spec/a_partial'
      get 'action_with_partial'
    end
    
    specify "spec should have access to flash" do
      get 'action_with_template'
      flash[:flash_key].should == "flash value"
    end

    specify "spec should have access to session" do
      get 'action_with_template'
      session[:session_key].should == "session value"
    end

    specify "custom routes should be speccable" do
      route_for(:controller => "custom_route_spec", :action => "custom_route").should_eql "/custom_route"
    end

    specify "routes should be speccable" do
      route_for(:controller => "controller_isolation_spec", :action => "some_action").should_eql "/controller_isolation_spec/some_action"
    end
  end
end

['integration', 'isolation'].each do |mode|
  context "Given a controller spec for RedirectSpecController running in #{mode} mode", :context_type => :controller do
    controller_name :redirect_spec
    integrate_views if mode == 'integration'

    specify "a redirect should ignore the absence of a template" do
      get 'action_with_redirect_to_somewhere'
      response.should_be_redirect
      response.redirect_url.should_eql "http://test.host/redirect_spec/somewhere"
      response.should_redirect_to "http://test.host/redirect_spec/somewhere"
    end
    
    specify "a call to response.should_redirect_to should fail if no redirect" do
      get 'action_with_no_redirect'
      lambda {
        #For some reason, if this is response.should_be_redirect it fires
        # a bunch of deprecation warnings against rails 1.2.0 RC 1. No idea why yet.
        response.redirect?.should_be true
      }.should_fail
      lambda {
        response.should_redirect_to "http://test.host/redirect_spec/somewhere"
      }.should_fail_with "expected redirect to http://test.host/redirect_spec/somewhere but there was no redirect"
    end
  end
end

