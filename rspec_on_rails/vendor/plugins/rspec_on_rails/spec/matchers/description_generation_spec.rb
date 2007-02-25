require File.dirname(__FILE__) + '/../spec_helper'

class DescriptionGenerationSpecController < ActionController::Base
  def render_action
  end
  
  def redirect_action
    redirect_to :action => :render_action
  end
end

context "Description generation", :context_type => :controller do
  controller_name :description_generation_spec
  setup do
    @desc = nil
    @callback = lambda { |desc| @desc = desc }
    Spec::Expectations::Matchers.description_generated(&@callback)
  end
  
  specify "should generate description for render_template" do
    get 'render_action'
    response.should render_template("render_action")
    @desc.should == "should render template \"render_action\""
  end
  
  specify "should generate description for render_template with full path" do
    get 'render_action'
    response.should render_template("description_generation_spec/render_action")
    @desc.should == "should render template \"description_generation_spec/render_action\""
  end
  
  specify "should generate description for redirect_to" do
    get 'redirect_action'
    response.should redirect_to("http://test.host/description_generation_spec/render_action")
    @desc.should == "should redirect to \"http://test.host/description_generation_spec/render_action\""
  end
  
end