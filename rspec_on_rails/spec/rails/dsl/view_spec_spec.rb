require File.dirname(__FILE__) + '/../../spec_helper'

describe "A template with an implicit helper", :behaviour_type => :view do
  before(:each) do
    render "view_spec/implicit_helper"
  end

  it "should include the helper" do
    response.should have_tag('div', :content => "This is text from a method in the ViewSpecHelper")
  end

  it "should include the application helper" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "A template requiring an explicit helper", :behaviour_type => :view do
  before(:each) do
    render "view_spec/explicit_helper", :helper => 'explicit'
  end

  it "should include the helper if specified" do
    response.should have_tag('div', :content => "This is text from a method in the ExplicitHelper")
  end

  it "should include the application helper" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "A template requiring multiple explicit helpers", :behaviour_type => :view do
  before(:each) do
    render "view_spec/multiple_helpers", :helpers => ['explicit', 'more_explicit']
  end

  it "should include all specified helpers" do
    response.should have_tag('div', :content => "This is text from a method in the ExplicitHelper")
    response.should have_tag('div', :content => "This is text from a method in the MoreExplicitHelper")
  end

  it "should include the application helper" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "A template that includes a partial", :behaviour_type => :view do
  def render!
    render "view_spec/template_with_partial"
  end

  it "should render the enclosing template" do
    render!
    response.should have_tag('div', "method_in_partial in ViewSpecHelper")
  end

  it "should render the partial" do
    render!
    response.should have_tag('div', "method_in_template_with_partial in ViewSpecHelper")
  end

  it "should include the application helper" do
    render!
    response.should have_tag('div', "This is text from a method in the ApplicationHelper")
  end
  
  it "should pass expect_partial with the right partial" do
    expect_partial('partial')
    render!
    template.verify_expected_partials
  end
  
  it "should fail expect_partial with the wrong partial" do
    expect_partial('non_existent')
    render!
    lambda {template.verify_expected_partials}.should raise_error(Spec::Mocks::MockExpectationError)
  end
  
  it "should fail expect_partial with the right partial but wrong options" do
    expect_partial('partial').with(:locals => {:thing => Object.new})
    render!
    lambda {template.verify_expected_partials}.should raise_error(Spec::Mocks::MockExpectationError)
  end
end

describe "A partial that includes a partial", :behaviour_type => :view do
  it "should support expect_partial with nested partial" do
    expect_partial('partial')
    render :partial => "view_spec/partial_with_sub_partial"
  end
end

describe "A view that includes a partial using :collection and :spacer_template", :behaviour_type => :view  do
  it "should render the partial w/ spacer_tamplate" do
    render "view_spec/template_with_partial_using_collection"
    response.should have_tag('div', :content => 'Alice')
    response.should have_tag('hr', :attributes =>{:id => "spacer"})
    response.should have_tag('div', :content => 'Bob')
  end

end

describe "A view that includes a partial using an array as partial_path", :behaviour_type => :view do
  before(:each) do
    module ActionView::Partials
      def render_template_with_partial_with_array_support(partial_path, local_assigns = nil, deprecated_local_assigns = nil)
        if partial_path.is_a?(Array)
          "Array Partial"
        else
          render_partial_without_array_support(partial_path, local_assigns, deprecated_local_assigns)
        end
      end

      alias :render_partial_without_array_support :render_partial
      alias :render_partial :render_template_with_partial_with_array_support
    end

    @array = ['Alice', 'Bob']
    assigns[:array] = @array
  end

  after(:each) do
    module ActionView::Partials
      alias :render_template_with_partial_with_array_support :render_partial
      alias :render_partial :render_partial_without_array_support
      undef render_template_with_partial_with_array_support
    end
  end

  it "should render have the array passed through to render_partial without modification" do
    render "view_spec/template_with_partial_with_array" 
    response.body.should match(/^Array Partial$/)
  end
end

describe "Different types of renders (not :template)", :behaviour_type => :view do
  it "should render partial with local" do
    render :partial => "view_spec/partial_with_local_variable", :locals => {:x => "Ender"}
    response.should have_tag('div', :content => "Ender")
  end
end

describe "A view", :behaviour_type => :view do
  before(:each) do
    session[:key] = "session"
    params[:key] = "params"
    flash[:key] = "flash"
    render "view_spec/accessor"
  end

  it "should have access to session data" do
    response.should have_tag("div#session", "session")
  end

  specify "should have access to params data" do
    response.should have_tag("div#params", "params")
  end

  it "should have access to flash data" do
    response.should have_tag("div#flash", "flash")
  end
end

describe "A view with a form_tag", :behaviour_type => :view do
  it "should render the right action" do
    render "view_spec/entry_form"
    response.should have_tag("form[action=?]","/view_spec/entry_form")
  end
end

module Spec
  module Rails
    module DSL
      describe ViewBehaviour do
        it "should tell you its behaviour_type is :view" do
          behaviour = ViewBehaviour.new("") {}
          behaviour.behaviour_type.should == :view
        end
      end
    end
  end
end
