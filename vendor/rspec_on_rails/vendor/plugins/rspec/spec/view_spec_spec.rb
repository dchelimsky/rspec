require File.dirname(__FILE__) + '/spec_helper'

context "Given a view with an implicit helper", :context_type => :view do
  specify "the helper should be included" do
    render "view_spec/show"
    response.should_have_tag 'div', :content => "This is text from a method in the ViewSpecHelper"
  end
end

context "Given a view requiring an explicit helper", :context_type => :view do
  specify "the helper should be included if specified" do
    render "view_spec/explicit_helper", :helper => 'explicit'
    response.should_have_tag 'div', :content => "This is text from a method in the ExplicitHelper"
  end
end

context "Given a view requiring multiple explicit helpers", :context_type => :view do
  specify "the helper should be included if specified" do
    render "view_spec/multiple_helpers", :helpers => ['explicit', 'more_explicit']
    response.should_have_tag 'div', :content => "This is text from a method in the ExplicitHelper"
    response.should_have_tag 'div', :content => "This is text from a method in the MoreExplicitHelper"
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
end

