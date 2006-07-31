require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

context "<%= class_name %> class with fixtures loaded" do
  fixtures :<%= table_name %>

  specify "should count two <%= class_name.pluralize %>" do
    <%= class_name %>.count.should_be 2
  end

  specify "should have more specifications" do
    violated "not enough specs"
  end
end
