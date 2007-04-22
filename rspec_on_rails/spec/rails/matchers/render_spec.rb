require File.dirname(__FILE__) + '/../../spec_helper'

['isolation','integration'].each do |mode|
  describe "response.should render_template (in #{mode} mode)",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end
    
    def on_edge?
      !(['1.1.6', '1.2.1', '1.2.2', '1.2.3'].include?(Rails::VERSION::STRING))
    end

    it "should match a simple path" do
      post 'some_action'
      response.should render_template('some_action')
    end

    it "should match a less simple path" do
      post 'some_action'
      response.should render_template('render_spec/some_action')
    end
  
    it "should match a symbol" do
      post 'some_action'
      response.should render_template(:some_action)
    end

    it "should match an rjs template" do
      xhr :post, 'some_action'
      if on_edge?
        response.should render_template('render_spec/some_action')
      else
        response.should render_template('render_spec/some_action.rjs')
      end
    end

    it "should fail on the wrong extension (given rhtml)" do
      get 'some_action'
      lambda {
        response.should render_template('render_spec/some_action.rjs')
      }.should fail_with("expected \"render_spec/some_action.rjs\", got \"render_spec/some_action\"")
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
      end.should fail_with("expected \"non_existent_template\", got \"some_action\"")
    end

    it "should fail when TEXT is rendered" do
      post 'text_action'
      lambda do
        response.should render_template('some_action')
      end.should fail_with("expected \"some_action\", got nil")
    end
  end

  describe "response.should have_text (in #{mode} mode)",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    it "should pass with exactly matching text" do
      post 'text_action'
      response.should have_text("this is the text for this action")
    end

    it "should pass with matching text (using Regexp)" do
      post 'text_action'
      response.should have_text(/is the text/)
    end

    it "should fail with matching text" do
      post 'text_action'
      lambda {
        response.should have_text("this is NOT the text for this action")
      }.should fail_with("expected \"this is NOT the text for this action\", got \"this is the text for this action\"")
    end

    it "should fail when a template is rendered" do
      post 'some_action'
      lambda {
        response.should have_text("this is the text for this action")
      }.should fail_with(/expected \"this is the text for this action\", got .*/)
    end
  end
end
