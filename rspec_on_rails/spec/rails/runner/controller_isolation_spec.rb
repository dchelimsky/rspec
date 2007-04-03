require File.dirname(__FILE__) + '/../../spec_helper'
require 'controller_isolation_spec_controller'

context "a controller spec running in isolation mode", :context_type => :controller do
  controller_name :controller_isolation_spec

  specify "should not care if the template doesn't exist" do
    get 'some_action'
    response.should be_success
    response.should render_template("template/that/does/not/actually/exist")
  end

  specify "should not care if the template has errors" do
    get 'action_with_errors_in_template'
    response.should be_success
    response.should render_template("action_with_errors_in_template")
  end

  specify "should not create any templates" do
    get 'some_action'
    response.body.should =~ /template\/that\/does\/not\/actually\/exist/
  end
end

context "a controller spec running in integration mode", :context_type => :controller do
  controller_name :controller_isolation_spec
  integrate_views
  
  setup do
    controller.class.send(:define_method, :rescue_action) { |e| raise e }
  end

  specify "should render a template" do
    get 'action_with_template'
    response.should be_success
    response.should have_tag('div', 'This is action_with_template.rhtml')
  end

  specify "should choke if the template doesn't exist" do
    lambda { get 'some_action' }.should raise_error(ActionController::MissingTemplate, /template\/that\/does\/not\/actually\/exist/)
    response.should_not be_success
  end

  specify "should choke if the template has errors" do
    lambda { get 'action_with_errors_in_template' }.should raise_error(ActionView::TemplateError)
    response.should_not be_success
  end
end