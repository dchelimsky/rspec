require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

context "The <%= class_name %>Controller" do
  # fixtures :<%= table_name %>
  controller_name :<%= class_name.underscore %>

  specify "should be a <%= class_name %>Controller" do
    controller.should.be.an.instance.of <%= class_name %>Controller
  end

<% for action in actions -%>

  specify "should accept GET to <%= action %>"
    get '<%= action %>'
    response.should.be.success
  end
<% end -%>

  specify "should have more specifications" do
    violated "not enough specs"
  end
end
