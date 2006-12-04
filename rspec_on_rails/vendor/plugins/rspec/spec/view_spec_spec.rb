require File.dirname(__FILE__) + '/spec_helper'

context "Given a view with an implicit helper", :context_type => :view do
  setup do
    render "view_spec/show"
  end

  specify "the helper should be included" do
    response.should_have_tag 'div', :content => "This is text from a method in the ViewSpecHelper"
  end

  specify "the application helper should be included" do
    response.should_have_tag 'div', :content => "This is text from a method in the ApplicationHelper"
  end
end

context "Given a view requiring an explicit helper", :context_type => :view do
  setup do
    render "view_spec/explicit_helper", :helper => 'explicit'
  end

  specify "the helper should be included if specified" do
    response.should_have_tag 'div', :content => "This is text from a method in the ExplicitHelper"
  end

  specify "the application helper should be included" do
    response.should_have_tag 'div', :content => "This is text from a method in the ApplicationHelper"
  end
end

context "Given a view requiring multiple explicit helpers", :context_type => :view do
  setup do
    render "view_spec/multiple_helpers", :helpers => ['explicit', 'more_explicit']
  end

  specify "all helpers should be included if specified" do
    response.should_have_tag 'div', :content => "This is text from a method in the ExplicitHelper"
    response.should_have_tag 'div', :content => "This is text from a method in the MoreExplicitHelper"
  end

  specify "the application helper should be included" do
    response.should_have_tag 'div', :content => "This is text from a method in the ApplicationHelper"
  end
end

context "Given a view that includes a partial", :context_type => :view do
  setup do
    render "view_spec/partial_including_template"
  end

  specify "the enclosing template should get rendered" do
    response.should_have_tag 'div', :content => "method_in_included_partial in ViewSpecHelper"
  end

  specify "the partial should get rendered" do
    response.should_have_tag 'div', :content => "method_in_partial_including_template in ViewSpecHelper"
  end

  specify "the application helper should be included" do
    response.should_have_tag 'div', :content => "This is text from a method in the ApplicationHelper"
  end
end

context "Given a view that includes a partial using :collection and :spacer_template", :context_type => :view  do
  setup do
    render "view_spec/partial_collection_including_template"
  end

  specify "the partial should get rendered w/ spacer_tamplate" do
    response.should_have_tag 'div', :content => 'Alice'
    response.should_have_tag 'hr', :attributes =>{:id => "spacer"}
    response.should_have_tag 'div', :content => 'Bob'
  end

end

context "Different types of renders (not :template)", :context_type => :view do

  specify "partial with local" do
    render :partial => "view_spec/partial_with_local_variable", :locals => {:x => "Ender"}
    response.should_have_tag 'div', :content => "Ender"
  end

  specify "file" do
    render :file => File.expand_path(File.dirname(__FILE__)) + "/../../../../app/views/view_spec/_partial_with_local_variable.rhtml", :locals => {:x => "Ender"}
    response.should_have_tag 'div', :content => "Ender"
  end

end
