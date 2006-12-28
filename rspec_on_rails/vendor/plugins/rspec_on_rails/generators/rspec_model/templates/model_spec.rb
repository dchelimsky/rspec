require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

#Delete this context and add some real ones
context "Given a generated <%= class_name.underscore %>_spec.rb with fixtures loaded" do
  fixtures :<%= table_name %>

  specify "fixtures should load two <%= class_name.pluralize %>" do
    <%= class_name %>.should_have(2).records
  end
end
