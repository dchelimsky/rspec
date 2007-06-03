require File.dirname(__FILE__) + '/../../spec_helper'
require 'controller_spec_controller'

['integration', 'isolation'].each do |mode|
  describe "Given a controller spec for ControllerSpecController running in #{mode} mode", :behaviour_type => :controller do
    controller_name :controller_spec
    integrate_views if mode == 'integration'
  
    it "session should be the same object as controller session" do
      get 'action_with_template'
      session.should equal(controller.session)
    end
  
    it "session should be the same object before and after the action" do
      session_before = session
      get 'action_with_template'
      session.should equal(session_before)
    end
  
    it "controller.session should NOT be nil before the action" do
      controller.session.should_not be_nil
      get 'action_with_template'
    end
    
    it "controller.session should NOT be nil after the action" do
      get 'action_with_template'
      controller.session.should_not be_nil
    end
    
    it "specifying a partial should work with partial name only" do
      get 'action_with_partial'
      response.should render_template("_a_partial")
    end
    
    it "specifying a partial should work with path relative to RAILS_ROOT/app/views/" do
      get 'action_with_partial'
      response.should render_template("controller_spec/_a_partial")
    end
    
    it "spec should have access to flash" do
      get 'action_with_template'
      flash[:flash_key].should == "flash value"
    end
    
    it "spec should have access to flash values set after a session reset" do
      get 'action_setting_flash_after_session_reset'
      flash[:after_reset].should == "available"
    end
    
    it "spec should not have access to flash values set before a session reset" do
      get 'action_setting_flash_before_session_reset'
      flash[:before_reset].should_not == "available"
    end

    it "spec should have access to session" do
      get 'action_with_template'
      session[:session_key].should == "session value"
    end

    it "custom routes should be speccable" do
      route_for(:controller => "custom_route_spec", :action => "custom_route").should == "/custom_route"
    end

    it "routes should be speccable" do
      route_for(:controller => "controller_spec", :action => "some_action").should == "/controller_spec/some_action"
    end

    it "exposes the assigns hash directly" do
      get 'action_setting_the_assigns_hash'
      assigns[:direct_assigns_key].should == :direct_assigns_key_value
    end
  end

  describe "Given a controller spec for RedirectSpecController running in #{mode} mode", :behaviour_type => :controller do
    controller_name :redirect_spec
    integrate_views if mode == 'integration'

    it "a redirect should ignore the absence of a template" do
      get 'action_with_redirect_to_somewhere'
      response.should be_redirect
      response.redirect_url.should == "http://test.host/redirect_spec/somewhere"
      response.should redirect_to("http://test.host/redirect_spec/somewhere")
    end
    
    it "a call to response.should redirect_to should fail if no redirect" do
      get 'action_with_no_redirect'
      lambda {
        response.redirect?.should be_true
      }.should fail
      lambda {
        response.should redirect_to("http://test.host/redirect_spec/somewhere")
      }.should fail_with("expected redirect to \"http://test.host/redirect_spec/somewhere\", got no redirect")
    end
  end
  
  describe "Given a controller spec running in #{mode} mode", :behaviour_type => :controller do
    integrate_views if mode == 'integration'
    it "a spec in a context without controller_name set should fail with a useful warning",
      :should_raise => [
        Spec::Expectations::ExpectationNotMetError,
        /You have to declare the controller name in controller specs/
      ] do
    end
  end
  
end

describe ControllerSpecController, :behaviour_type => :controller do
  it "should not require naming the controller if describe is passed a type" do
  end
end

module Spec
  module Rails
    module DSL
      describe ControllerBehaviour do
        it "should tell you its behaviour_type is :controller" do
          behaviour = ControllerBehaviour.new("") {}
          behaviour.behaviour_type.should == :controller
        end
      end
    end
  end
end
