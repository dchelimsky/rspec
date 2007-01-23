require File.dirname(__FILE__) + '/../spec_helper'

['isolation','integration'].each do |mode|
  context "response.should render_template (in #{mode} mode)",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "should match a simple path" do
      post 'some_action'
      response.should render_template('some_action')
    end

    specify "should match a less simple path" do
      post 'some_action'
      response.should render_template('render_spec/some_action')
    end
  
    specify "should match a symbol" do
      post 'some_action'
      response.should render_template(:some_action)
    end

    specify "should match an rjs template" do
      xhr :post, 'some_action'
      response.should render_template('render_spec/some_action.rjs')
    end

    specify "should fail when the wrong template is rendered" do
      post 'some_action'
      lambda do
        response.should render_template('non_existent_template')
      end.should_fail_with "expected \"non_existent_template\", got \"some_action\""
    end

    specify "should fail when TEXT is rendered" do
      post 'text_action'
      lambda do
        response.should render_template('some_action')
      end.should_fail_with "expected \"some_action\", got nil"
    end
  end

  context "response.should render_text (in #{mode} mode)",
    :context_type => :controller do
    controller_name :render_spec
    if mode == 'integration'
      integrate_views
    end

    specify "should pass with matching text" do
      post 'text_action'
      response.should render_text("this the text for this action")
    end

    specify "should fail with matching text" do
      post 'text_action'
      lambda {
        response.should render_text("this is NOT the text for this action")
      }.should_fail_with "expected \"this is NOT the text for this action\", got \"this the text for this action\""
    end

    specify "should fail when a template is rendered" do
      post 'some_action'
      lambda {
        response.should render_text("this the text for this action")
      }.should_fail_with /expected \"this the text for this action\", got .*/
    end
  end
end
