require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

context "<%= class_name %> class with fixtures loaded" do
  fixtures :<%= table_name %>

  specify "should count two <%= class_name.pluralize %>" do
    <%= class_name %>.count.should.be 2
  end

  specify "should have more specifications" do
    violated "nothing specified"
  end
end

context "<%= class_name %> fixture :first" do
  fixtures :<%= table_name %>

  setup do
    @first = <%= class_name.pluralize.underscore %>(:first)
  end

  specify "should have more specifications" do
    violated "nothing specified"
  end
end
