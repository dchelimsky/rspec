require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

#Delete this context and add some real ones
describe <%= class_name %>Controller do
  controller_name '<%= class_name.underscore %>'
  
  it "should use <%= class_name %>Controller" do
    controller.should be_an_instance_of(<%= class_name %>Controller)
  end
end

<% unless actions.empty? -%>
describe <%= class_name %>Controller do
  controller_name '<%= class_name.underscore %>'
<% for action in actions -%>

  specify "GET '<%= action %>' should be successful" do
    get '<%= action %>'
    response.should be_success
  end
<% end -%>
end
<% end -%>