require File.dirname(__FILE__) + '/../spec_helper'

[true, false].each do |do_integration|
  if do_integration
    name = "Given a controller spec in integration mode"
  else
    name = "Given a controller spec in isolation (default) mode"
  end
  context name, :context_type => :controller do
    controller_name :render_spec
    if do_integration
      integrate_views
    end
  
    specify "you should be able to state 'should_render' before a post to an action" do
      controller.should_render :template => 'render_spec/some_action'
      post 'some_action'
    end
  
    specify "you should be able to state 'should_render' after a post to an action" do
      post 'some_action'
      controller.should_have_rendered :template => 'render_spec/some_action'
    end
  
    specify "a 'should_render' expectation should fail if placed before an action" do
      controller.should_render :template => 'non_existent_template'
      lambda { post 'some_action' }.should_raise#fail_with "<{:template=>\"non_existent_template\"}> should == <{:template=>\"render_spec/some_action\"}>"
    end

    specify "a 'should_render' expectation should fail if placed after an action" do
      post 'some_action'
      lambda { controller.should_have_rendered :template => 'non_existent_template' }.should_fail
    end
  
    specify "a 'should_render' expectation should support :text after the action" do
      post 'text_action'
      controller.should_have_rendered :text => "this the text for this action"
    end
  
    specify "a 'should_render' expectation should support :text before the action" do
      controller.should_render :text => "this the text for this action"
      post 'text_action'
    end
  end
end
