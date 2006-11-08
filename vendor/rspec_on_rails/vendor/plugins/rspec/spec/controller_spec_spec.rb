require File.dirname(__FILE__) + '/spec_helper'

['integration', 'isolation'].each do |mode|
  context "Given a controller spec running in #{mode} mode", :context_type => :controller do
    controller_name :controller_isolation_spec
    integrate_views if mode == 'integration'
  
    specify "session should be the same object as controller session" do
      get 'action_with_implied_template'
      session.should_equal controller.session
    end
  
    specify "session should be the same object before and after the action" do
      session_before = session
      get 'action_with_implied_template'
      session.should_equal session_before
    end
  
    specify "controller.session should NOT be nil before the action" do
      controller.session.should_not_be nil
      get 'action_with_implied_template'
    end
    
    specify "controller.session should NOT be nil before the action" do
      get 'action_with_implied_template'
      controller.session.should_not_be nil
    end
  end
end

['integration', 'isolation'].each do |mode|
  context "Given a controller spec running in #{mode} mode", :context_type => :controller do
    controller_name :redirect_spec
    integrate_views if mode == 'integration'

    specify "a redirect should ignore the absence of a template" do
      get 'action_with_redirect_to_somewhere'
      response.should_be_redirect
      response.redirect_url.should_eql "http://test.host/redirect_spec/somewhere"
    end
  end
end

