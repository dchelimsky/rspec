require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

context "The <%= class_name %>Helper" do
  helper_name :<%= class_name.underscore %>
end
