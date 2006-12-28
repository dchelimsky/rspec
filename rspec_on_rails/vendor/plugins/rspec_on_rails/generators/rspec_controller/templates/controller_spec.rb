require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

#Delete this context and add some real ones
context "Given a generated <%= class_name.underscore %>_controller_spec.rb" do
  controller_name '<%= class_name.underscore %>'
  
  specify "the controller should be a<%= class_name =~ /A|E|I|O|U/ ? 'n' : ''%> <%= class_name %>Controller" do
    controller.should_be_an_instance_of <%= class_name %>Controller
  end
end

<% unless actions.empty? -%>
context "Given a<%= class_name =~ /A|E|I|O|U/ ? 'n' : ''%> <%= class_name %>Controller" do
  controller_name '<%= class_name.underscore %>'
<% for action in actions -%>

  specify "GET '<%= action %>' should be successful" do
    get '<%= action %>'
    response.should_be_success
  end
<% end -%>
end
<% end -%>