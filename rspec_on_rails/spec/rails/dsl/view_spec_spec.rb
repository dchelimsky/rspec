require File.dirname(__FILE__) + '/../../spec_helper'

describe "Given a view with an implicit helper", :behaviour_type => :view do
  setup do
    render "view_spec/show"
  end

  it "the helper should be included" do
    response.should have_tag('div', :content => "This is text from a method in the ViewSpecHelper")
  end

  it "the application helper should be included" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "Given a view requiring an explicit helper", :behaviour_type => :view do
  setup do
    render "view_spec/explicit_helper", :helper => 'explicit'
  end

  it "the helper should be included if specified" do
    response.should have_tag('div', :content => "This is text from a method in the ExplicitHelper")
  end

  it "the application helper should be included" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "Given a view requiring multiple explicit helpers", :behaviour_type => :view do
  setup do
    render "view_spec/multiple_helpers", :helpers => ['explicit', 'more_explicit']
  end

  it "all helpers should be included if specified" do
    response.should have_tag('div', :content => "This is text from a method in the ExplicitHelper")
    response.should have_tag('div', :content => "This is text from a method in the MoreExplicitHelper")
  end

  it "the application helper should be included" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "Given a view that includes a partial", :behaviour_type => :view do
  setup do
    render "view_spec/partial_including_template"
  end

  it "the enclosing template should get rendered" do
    response.should have_tag('div', :content => "method_in_included_partial in ViewSpecHelper")
  end

  it "the partial should get rendered" do
    response.should have_tag('div', :content => "method_in_partial_including_template in ViewSpecHelper")
  end

  it "the application helper should be included" do
    response.should have_tag('div', :content => "This is text from a method in the ApplicationHelper")
  end
end

describe "Given a view that includes a partial using :collection and :spacer_template", :behaviour_type => :view  do
  setup do
    render "view_spec/partial_collection_including_template"
  end

  it "the partial should get rendered w/ spacer_tamplate" do
    response.should have_tag('div', :content => 'Alice')
    response.should have_tag('hr', :attributes =>{:id => "spacer"})
    response.should have_tag('div', :content => 'Bob')
  end

end

describe "Given a view that includes a partial using an array as partial_path", :behaviour_type => :view do
  setup do
    module ActionView::Partials
      def render_partial_with_array_support(partial_path, local_assigns = nil, deprecated_local_assigns = nil)
        if partial_path.is_a?(Array)
          "Array Partial"
        else
          render_partial_without_array_support(partial_path, local_assigns, deprecated_local_assigns)
        end
      end

      alias :render_partial_without_array_support :render_partial
      alias :render_partial :render_partial_with_array_support
    end

    @array = ['Alice', 'Bob']
    assigns[:array] = @array
  end

  teardown do
    module ActionView::Partials
      alias :render_partial_with_array_support :render_partial
      alias :render_partial :render_partial_without_array_support
      undef render_partial_with_array_support
    end
  end

  it "the array should be passed through to render_partial without modification" do
    render "view_spec/partial_with_array" 
    response.body.should match(/^Array Partial$/)
  end
end

describe "Different types of renders (not :template)", :behaviour_type => :view do
  it "partial with local" do
    render :partial => "view_spec/partial_with_local_variable", :locals => {:x => "Ender"}
    response.should have_tag('div', :content => "Ender")
  end
end

describe "A view", :behaviour_type => :view do
  setup do
    session[:key] = "session"
    params[:key] = "params"
    flash[:key] = "flash"
    render "view_spec/accessor"
  end

  it "should have access to session data" do
    response.should have_tag("div#session", "session")
  end

  # specify "should have access to params data" do
  #   response.should have_tag("div#params", "params")
  # end

  it "should have access to flash data" do
    response.should have_tag("div#flash", "flash")
  end
end

unless Rails::VERSION::STRING == "1.1.6" #1.1.6 did not have form_tag
  describe "A view with a form_tag", :behaviour_type => :view do
    it "should render the right action" do
      render "view_spec/entry_form"
      response.should have_tag("form[action=?]","/view_spec/entry_form")
    end
  end
end