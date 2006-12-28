require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

#Delete this context and add some real ones or delete this file
context "Given a generated <%= class_name.underscore %>_helper_spec.rb" do
  helper_name '<%= class_name.underscore %>'
  
  specify "the <%= class_name %>Helper should be included" do
    (class << self; self; end).class_eval do
      included_modules.should_include <%= class_name %>Helper
    end
  end
end
