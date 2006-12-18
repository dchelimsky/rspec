require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "Given a controller spec in #{mode} mode",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "you should be able to state 'should_render' before a post to an action" do
      controller.should_render :template => 'render_spec/some_action'
      post 'some_action'
    end

    specify "you should be able to state 'should_render' after a post to an action" do
      post 'some_action'
      controller.should_render :template => 'render_spec/some_action'
    end

    specify "you should be able to use a symbol before a post to an action" do
      controller.should_render :some_action
      post 'some_action'
    end

    specify "you should be able to use a symbol after a post to an action" do
      post 'some_action'
      controller.should_render :some_action
    end

    specify "you should be able to use a String before a post to an action" do
      controller.should_render 'some_action'
      post 'some_action'
    end

    specify "you should be able to use a String after a post to an action" do
      post 'some_action'
      controller.should_render 'some_action'
    end

    specify "a 'should_render' expectation should fail if placed before an action that renders something different" do
      controller.should_render :template => 'non_existent_template'
      lambda do
        post 'some_action'
      end.should_fail_with "{:template=>\"render_spec/some_action\"} should == {:template=>\"non_existent_template\"}"
    end

    specify "a 'should_render' expectation should fail if placed after an action that renders something different" do
      post 'some_action'
      lambda do
        controller.should_render :template => 'non_existent_template'
      end.should_fail_with "{:template=>\"render_spec/some_action\"} should == {:template=>\"non_existent_template\"}"
    end

    specify "a 'should_render' expectation should support :text before the action" do
      controller.should_render :text => "this the text for this action"
      post 'text_action'
    end

    specify "a 'should_render' expectation should support :text after the action" do
      post 'text_action'
      controller.should_render :text => "this the text for this action"
    end
    
    specify "a 'should_render' expectation should support an Ajax request and RJS template before the action" do
      controller.should_render :template => 'render_spec/some_action.rjs'
      xhr :post, 'some_action'
    end
    
    specify "a 'should_render' expectation should support an Ajax request and RJS template after the action" do
      xhr :post, 'some_action'
      controller.should_render :template => 'render_spec/some_action.rjs'
    end
  end
end
