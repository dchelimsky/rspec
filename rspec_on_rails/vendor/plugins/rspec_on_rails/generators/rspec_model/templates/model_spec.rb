require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

#Delete this context and add some real ones
describe <%= class_name %>, " fixtures" do
  fixtures :<%= table_name %>

  it "should load two <%= class_name.pluralize %>" do
    <%= class_name %>.should have(2).records
  end
end
