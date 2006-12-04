require File.dirname(__FILE__) + '/spec_helper'

context "a controller spec running in isolation mode", :context_type => :controller do
  controller_name :controller_isolation_spec
  
  specify "should not care if the template doesn't exist" do
    controller.should_render :template => "/file/that/does/not/actually/exist"
    get 'some_action'
    response.should_be_success
  end
  
  specify "should not care if the template has errors" do
    controller.should_render :template => "controller_isolation_spec/action_with_errors_in_template"
    get 'action_with_errors_in_template'
    response.should_be_success
  end
  
  specify "should not create any templates" do
    get 'some_action'
    response.template.instance_variables.should_not_include "@template"
  end
end

context "a controller spec running in integration mode", :context_type => :controller do
  controller_name :controller_isolation_spec
  integrate_views

  specify "should render a template" do
    get 'action_with_template'
    response.should_be_success
    response.should_have_tag 'div', :content => "This is action_with_template.rhtml"
  end
  
  specify "should render a template explicitly specified in an action" do
    get 'action_with_specified_template'
    response.should_be_success
    response.should_have_tag 'div', :content => "This template, \"specified_template.rhtml\", is specified by the controller"
  end
  
  specify "should choke if the template doesn't exist" do
    lambda { get 'some_action' }.should_raise ActionController::MissingTemplate
    response.should_not_be_success
  end
  
  specify "should choke if the template has errors" do
    lambda { get 'action_with_errors_in_template' }.should_raise ActionView::TemplateError
    response.should_not_be_success
  end
end

