require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

context "Rendering /<%= model %>/<%= action %>" do
  # fixtures :<%= table_name %>
  controller_name :<%= model.underscore %>

  specify "should have more specifications" do
    violated "not enough specs"
  end
end
