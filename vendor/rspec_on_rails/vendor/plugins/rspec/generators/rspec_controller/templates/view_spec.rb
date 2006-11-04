require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper'

context "/<%= model %>/<%= action %>" do
  specify "should have more specifications" do
    violated "not enough specs"
  end
end
