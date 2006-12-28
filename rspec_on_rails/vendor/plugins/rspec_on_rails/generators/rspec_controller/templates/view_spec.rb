require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper'

context "Given a request to render <%= class_name.underscore %>/<%= action %>" do
  setup do
    render '<%= class_name.underscore %>/<%= action %>'
  end
  
  specify "the response should tell you where to find the file" do
    response.should_have_tag 'p', :content => 'Find me in app/views/<%= class_name.underscore %>/<%= action %>.rhtml'
  end
end
