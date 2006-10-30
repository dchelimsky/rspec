require File.dirname(__FILE__) + '/../spec_helper'

context "Given a controller spec in isolation (default) mode", :context_type => :controller do
  controller_name :render_spec
  
  # specify "you should be able to state 'should_render' before a post to an action" do
  #   controller.should_render :template => 'render_spec/some_action'
  #   post 'some_action'
  # end
  
  specify "you should be able to state 'should_render' after a post to an action" do
    post 'some_action'
    controller.should_render :template => 'render_spec/some_action'
  end

end
