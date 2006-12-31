require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "Given a controller spec in #{mode} mode, should_redirect_to should pass when", :context_type => :controller do
    if mode == 'integration'
      integrate_views
    end
    controller_name :redirect_spec
  
    specify "redirected to another action" do
      controller.should_redirect_to :action => 'somewhere'
      get 'action_with_redirect_to_somewhere'
    end
  
    specify "redirected to another action (with 'and return')" do
      controller.should_redirect_to :action => 'somewhere'
      get 'action_with_redirect_to_somewhere_and_return'
    end
  
    specify "redirected to correct path with leading /" do
      controller.should_redirect_to '/redirect_spec/somewhere'
      get 'action_with_redirect_to_somewhere'
      response.should_redirect_to '/redirect_spec/somewhere'
    end
    
    specify "redirected to correct path without leading /" do
      controller.should_redirect_to 'redirect_spec/somewhere'
      get 'action_with_redirect_to_somewhere'
      response.should_redirect_to 'redirect_spec/somewhere'
    end
    
    specify "redirected to correct internal URL" do
      controller.should_redirect_to "http://test.host/redirect_spec/somewhere"
      get 'action_with_redirect_to_somewhere'
      response.should_redirect_to "http://test.host/redirect_spec/somewhere"
    end

    specify "redirected to correct external URL" do
      controller.should_redirect_to "http://rspec.rubyforge.org"
      get 'action_with_redirect_to_rspec_site'
      response.should_redirect_to "http://rspec.rubyforge.org"
    end
  
    specify "redirected :back" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      controller.should_redirect_to :back
      get 'action_with_redirect_back'
      response.should_redirect_to "http://test.host/previous/page"
    end
  
    specify "redirected :back and should_redirect_to URL matches" do
      request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      controller.should_redirect_to "http://test.host/previous/page"
      get 'action_with_redirect_back'
      response.should_redirect_to "http://test.host/previous/page"
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
    
    specify "redirected to wrong action",
      :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to {:action=>"somewhere_else"} but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
      controller.should_redirect_to :action => 'somewhere_else'
      get 'action_with_redirect_to_somewhere'
    end
    
    specify "redirected to incorrect path with leading /",
      :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "/redirect_spec/somewhere_else" but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
      controller.should_redirect_to '/redirect_spec/somewhere_else'
      get 'action_with_redirect_to_somewhere'
    end

    specify "redirected to incorrect path without leading /",
      :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "redirect_spec/somewhere_else" but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
      controller.should_redirect_to 'redirect_spec/somewhere_else'
      get 'action_with_redirect_to_somewhere'
    end

    specify "redirected to incorrect internal URL (based on the action)",
    :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://test.host/redirect_spec/somewhere_else" but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
      controller.should_redirect_to "http://test.host/redirect_spec/somewhere_else"
      get 'action_with_redirect_to_somewhere'
    end
    
    specify "redirected to wrong external URL",
    :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://test.unit.rubyforge.org" but redirected to "http://rspec.rubyforge.org" instead'] do
      controller.should_redirect_to "http://test.unit.rubyforge.org"
      get 'action_with_redirect_to_rspec_site'
    end

    specify "redirected to incorrect internal URL (based on the directory path)",
    :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://test.host/non_existent_controller/somewhere" but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
      controller.should_redirect_to "http://test.host/non_existent_controller/somewhere"
      get 'action_with_redirect_to_somewhere'
    end

    specify "expected redirect :back, but redirected to a new URL",
      :should_raise => [Spec::Mocks::MockExpectationError, 'controller expected call to redirect_to :back but it was never received'] do
      controller.should_redirect_to :back
      get 'action_with_no_redirect'
    end

    specify "no redirect at all",
      :should_raise => [Spec::Mocks::MockExpectationError, 'controller expected call to redirect_to {:action=>"nowhere"} but it was never received'] do
      controller.should_redirect_to :action => 'nowhere'
      get 'action_with_no_redirect'
    end

  end
end
