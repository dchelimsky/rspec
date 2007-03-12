require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper'

describe "/<%= class_name.underscore %>/<%= action %>" do
  setup do
    render '<%= class_name.underscore %>/<%= action %>'
  end
  
  it "should tell you where to find the file" do
    response.should have_tag('p', 'Find me in app/views/<%= class_name.underscore %>/<%= action %>.rhtml')
  end
end
