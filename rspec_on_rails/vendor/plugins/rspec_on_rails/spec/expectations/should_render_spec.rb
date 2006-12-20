require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "Given a controller spec in #{mode} mode, the following should be supported",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "controller.should_render :template before an action" do
      controller.should_render :template => 'render_spec/some_action'
      post 'some_action'
    end

    specify "controller.should_render :template after an action" do
      post 'some_action'
      controller.should_render :template => 'render_spec/some_action'
    end

    specify "response.should_render :template after an action" do
      post 'some_action'
      response.should_render :template => 'render_spec/some_action'
    end

    specify "controller.should_render :symbol before an action" do
      controller.should_render :some_action
      post 'some_action'
    end

    specify "controller.should_render :symbol after an action" do
      post 'some_action'
      controller.should_render :some_action
    end

    specify "response.should_render :symbol after an action" do
      post 'some_action'
      response.should_render :some_action
    end

    specify "controller.should_render 'string' before an action" do
      controller.should_render 'some_action'
      post 'some_action'
    end

    specify "controller.should_render 'string' after an action" do
      post 'some_action'
      controller.should_render 'some_action'
    end

    specify "response.should_render 'string' after an action" do
      post 'some_action'
      response.should_render 'some_action'
    end

    specify "controller.should_render :text before an action" do
      controller.should_render :text => "this the text for this action"
      post 'text_action'
    end

    specify "controller.should_render :text after an action" do
      post 'text_action'
      controller.should_render :text => "this the text for this action"
    end

    specify "response.should_render :text after an action" do
      post 'text_action'
      response.should_render :text => "this the text for this action"
    end
    
    specify "controller.should_render with an Ajax request and RJS template before the action" do
      controller.should_render :template => 'render_spec/some_action.rjs'
      xhr :post, 'some_action'
    end
    
    specify "controller.should_render with an Ajax request and RJS template before the action" do
      xhr :post, 'some_action'
      controller.should_render :template => 'render_spec/some_action.rjs'
    end
    
    specify "response.should_render with an Ajax request and RJS template before the action" do
      xhr :post, 'some_action'
      response.should_render :template => 'render_spec/some_action.rjs'
    end
  end
  
  context "Given a controller spec in #{mode} mode, the following should be fail:",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "controller.should_render :template before an action that renders something different" do
      controller.should_render :template => 'non_existent_template'
      lambda do
        post 'some_action'
      end.should_fail_with "{:template=>\"render_spec/some_action\"} should == {:template=>\"non_existent_template\"}"
    end

    specify "controller.should_render :template after an action that renders something different" do
      post 'some_action'
      lambda do
        controller.should_render :template => 'non_existent_template'
      end.should_fail_with "{:template=>\"render_spec/some_action\"} should == {:template=>\"non_existent_template\"}"
    end

    specify "response.should_render :template after an action that renders something different" do
      post 'some_action'
      lambda do
        response.should_render :template => 'non_existent_template'
      end.should_fail_with "{:template=>\"render_spec/some_action\"} should == {:template=>\"non_existent_template\"}"
    end
  end
end
