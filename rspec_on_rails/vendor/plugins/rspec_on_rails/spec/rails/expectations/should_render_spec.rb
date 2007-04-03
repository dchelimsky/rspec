require File.dirname(__FILE__) + '/../../spec_helper'

['isolation','integration'].each do |mode|
  context "Given a controller spec in #{mode} mode, the following should be supported",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    setup do
      controller.class.send(:define_method, :rescue_action) { |e| raise e }
    end

    specify "controller.should_render :template before an action" do
      #Gone for 0.9
      controller.should_render :template => 'render_spec/some_action'
      post 'some_action'
    end

    specify "controller.should_render :template after an action" do
      post 'some_action'
      #Gone for 0.9
      controller.should_render :template => 'render_spec/some_action'
    end

    specify "response.should_render :template after an action" do
      post 'some_action'
      #Gone for 0.9
      response.should_render :template => 'render_spec/some_action'
      #0.8
      response.should render_template('render_spec/some_action')
    end

    specify "controller.should_render :symbol before an action" do
      #Gone for 0.9
      controller.should_render :some_action
      post 'some_action'
    end

    specify "controller.should_render :symbol after an action" do
      post 'some_action'
      #Gone for 0.9
      controller.should_render :some_action
    end

    specify "response.should_render :symbol after an action" do
      post 'some_action'
      #Gone for 0.9
      response.should_render :some_action
      #0.8
      response.should render_template(:some_action)
    end

    specify "controller.should_render 'string' before an action" do
      #Gone for 0.9
      controller.should_render 'some_action'
      post 'some_action'
    end

    specify "controller.should_render 'string' after an action" do
      post 'some_action'
      #Gone for 0.9
      controller.should_render 'some_action'
    end

    specify "response.should_render 'string' after an action" do
      #Gone for 0.9
      post 'some_action'
      response.should_render 'some_action'
      #0.8
      response.should render_template('some_action')
    end

    specify "controller.should_render :text before an action" do
      #Gone for 0.9
      controller.should_render :text => "this is the text for this action"
      post 'text_action'
    end

    specify "controller.should_render :text after an action" do
      post 'text_action'
      #Gone for 0.9
      controller.should_render :text => "this is the text for this action"
    end

    specify "response.should_render :text after an action" do
      post 'text_action'
      #Gone for 0.9
      response.should_render :text => "this is the text for this action"
      #0.8
      response.should have_text("this is the text for this action")
    end
    
    specify "controller.should_render with an Ajax request and RJS template before the action" do
      #Gone for 0.9
      controller.should_render :template => 'render_spec/some_action.rjs'
      xhr :post, 'some_action'
    end
    
    specify "controller.should_render with an Ajax request and RJS template before the action" do
      xhr :post, 'some_action'
      #Gone for 0.9
      controller.should_render :template => 'render_spec/some_action.rjs'
    end
    
    specify "response.should_render with an Ajax request and RJS template before the action" do
      xhr :post, 'some_action'
      #Gone for 0.9
      response.should_render :template => 'render_spec/some_action.rjs'
      #0.8
      response.should render_template('render_spec/some_action.rjs')
    end
  end
  
  context "Given a controller spec in #{mode} mode, the following should be fail:",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "controller.should_render :template before an action that renders something different" do
      #Gone for 0.9
      controller.should_render :template => 'non_existent_template'
      lambda do
        post 'some_action'
      end.should_fail_with "expected {:template=>\"non_existent_template\"}, got {:template=>\"render_spec/some_action\"} (using ==)"
    end

    specify "controller.should_render :template after an action that renders something different" do
      post 'some_action'
      lambda do
        #Gone for 0.9
        controller.should_render :template => 'non_existent_template'
      end.should_fail_with "expected {:template=>\"non_existent_template\"}, got {:template=>\"render_spec/some_action\"} (using ==)"
    end

    specify "response.should_render :template after an action that renders something different" do
      post 'some_action'
      lambda do
        #Gone for 0.9
        response.should_render :template => 'non_existent_template'
      end.should_fail_with "expected {:template=>\"non_existent_template\"}, got {:template=>\"render_spec/some_action\"} (using ==)"
      lambda do
        #0.8
        response.should render_template('non_existent_template')
      end.should_fail_with "expected \"non_existent_template\", got \"some_action\""
    end
  end
end
