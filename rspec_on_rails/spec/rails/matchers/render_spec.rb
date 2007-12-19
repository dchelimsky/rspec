require File.dirname(__FILE__) + '/../../spec_helper'

['isolation','integration'].each do |mode|
  describe "response.should render_template (in #{mode} mode)",
    :type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end
    
    it "should match a simple path" do
      post 'some_action'
      response.should render_template('some_action')
    end

    it "should match a less simple path" do
      post 'some_action'
      response.should render_template('render_spec/some_action')
    end
  
    it "should match a less simple path to another controller" do
      post 'action_which_renders_template_from_other_controller'
      response.should render_template('controller_spec/action_with_template')
    end
  
    it "should match a symbol" do
      post 'some_action'
      response.should render_template(:some_action)
    end

    it "should match an rjs template" do
      xhr :post, 'some_action'
      if ActionView::Base.const_defined?('DEFAULT_TEMPLATE_HANDLER_PREFERENCE') ||
				 ActionView::Base.respond_to?(:handler_for_extension) then
        response.should render_template('render_spec/some_action')
      else
        response.should render_template('render_spec/some_action.rjs')
      end
    end

    it "should match a partial template (simple path)" do
      get 'action_with_partial'
      response.should render_template("_a_partial")
    end

    it "should match a partial template (complex path)" do
      get 'action_with_partial'
      response.should render_template("render_spec/_a_partial")
    end

    it "should fail when the wrong template is rendered" do
      post 'some_action'
      lambda do
        response.should render_template('non_existent_template')
      end.should fail_with("expected \"non_existent_template\", got \"render_spec/some_action\"")
    end

    it "should fail without full path when template is associated with a different controller" do
      post 'action_which_renders_template_from_other_controller'
      lambda do
        response.should render_template('action_with_template')
      end.should fail_with(%Q|expected "action_with_template", got "controller_spec/action_with_template"|)
    end

    it "should fail with incorrect full path when template is associated with a different controller" do
      post 'action_which_renders_template_from_other_controller'
      lambda do
        response.should render_template('render_spec/action_with_template')
      end.should fail_with(%Q|expected "render_spec/action_with_template", got "controller_spec/action_with_template"|)
    end

    it "should fail on the wrong extension (given rhtml)" do
      get 'some_action'
      lambda {
        response.should render_template('render_spec/some_action.rjs')
      }.should fail_with("expected \"render_spec/some_action.rjs\", got \"render_spec/some_action\"")
    end

    it "should fail when TEXT is rendered" do
      post 'text_action'
      lambda do
        response.should render_template('some_action')
      end.should fail_with("expected \"some_action\", got nil")
    end
  end
end
