require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

describe <%= class_name %>Helper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the <%= class_name %>Helper" do
    included_modules = (class << self; self; end).send :included_modules
    included_modules.should include(<%= class_name %>Helper)
  end
  
end
