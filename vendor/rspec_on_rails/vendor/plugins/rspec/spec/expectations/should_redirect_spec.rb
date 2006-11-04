require File.dirname(__FILE__) + '/../spec_helper'

context "Given a controller spec in isolation (default) mode, should_redirect_to should pass when", :context_type => :controller do
  controller_name :redirect_spec
  
  specify "redirected to correct action" do
    controller.should_redirect_to :action => 'somewhere'
    get 'action_with_redirect_to_somewhere'
  end
  
  specify "redirected to correct URL" do
    controller.should_redirect_to "http://rspec.rubyforge.org"
    get 'action_with_redirect_to_rspec_site'
  end

end

context "Given a controller spec in isolation (default) mode, should_redirect_to should pass when", :context_type => :controller do
  controller_name :redirect_spec
  
  specify "redirected to wrong action",
    :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to {:action=>"somewhere_else"} but redirected to {:action=>"somewhere"} instead'] do
    controller.should_redirect_to :action => 'somewhere_else'
    get 'action_with_redirect_to_somewhere'
  end

  specify "redirected to wrong external URL",
  :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://test.unit.rubyforge.org" but redirected to "http://rspec.rubyforge.org" instead'] do
    controller.should_redirect_to "http://test.unit.rubyforge.org"
    get 'action_with_redirect_to_rspec_site'
  end
  
  specify "redirected to incorrect internal URL",
  :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to {:action=>"somewhere_else"} but redirected to {:action=>"somewhere"} instead'] do
    controller.should_redirect_to "http://test.host/redirect_spec/somewhere_else"
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

context "Given a controller spec in integration mode, should_redirect_to should pass when", :context_type => :controller do
  controller_name :redirect_spec
  integrate_views
  
  specify "redirected to correct action" do
    controller.should_redirect_to :action => 'somewhere'
    get 'action_with_redirect_to_somewhere'
  end
  
  specify "redirected to correct external URL" do
    controller.should_redirect_to "http://rspec.rubyforge.org"
    get 'action_with_redirect_to_rspec_site'
  end
end

context "Given a controller spec in integration mode, should_redirect_to should fail when", :context_type => :controller do
  controller_name :redirect_spec
  integrate_views
  
  specify "no redirect at all",
    :should_raise => [Spec::Mocks::MockExpectationError, 'controller expected call to redirect_to {:action=>"nowhere"} but it was never received'] do
    controller.should_redirect_to :action => 'nowhere'
    get 'action_with_no_redirect'
  end
  
  specify "redirected to wrong action",
    :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to {:action=>"somewhere_else"} but redirected to {:action=>"somewhere"} instead'] do
    controller.should_redirect_to :action => 'somewhere_else'
    get 'action_with_redirect_to_somewhere'
  end
  
  specify "redirected to incorrect external URL",
  :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://rubyforge.org" but redirected to "http://rspec.rubyforge.org" instead'] do
    controller.should_redirect_to "http://rubyforge.org"
    get 'action_with_redirect_to_rspec_site'
  end
  
  specify "redirected to incorrect internal URL",
  :should_raise => [Spec::Expectations::ExpectationNotMetError, 'expected redirect to "http://test.host/redirect_spec/somewhere_else" but redirected to "http://test.host/redirect_spec/somewhere" instead'] do
    controller.should_redirect_to "http://test.host/redirect_spec/somewhere_else"
    get 'action_with_redirect_to_somewhere'
  end
end


