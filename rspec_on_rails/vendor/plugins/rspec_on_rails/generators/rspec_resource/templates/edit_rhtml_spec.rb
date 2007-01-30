require File.dirname(__FILE__) + '/../../spec_helper'

context "/<%= table_name %>/edit.rhtml" do
  include <%= controller_class_name %>Helper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @<%= file_name %> = mock_model(<%= class_name %>, :errors => @errors)<% for attribute in attributes -%>
    @<%= file_name %>.stub!(:<%= attribute.name %>).and_return(<%= attribute.default_value %>)<% end -%>

    assigns[:<%= file_name %>] = @<%= file_name %>
  end

  specify "should render edit form" do
    render "/<%= table_name %>/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => <%= file_name %>_path(@<%= file_name %>), :method => 'post'}
<% for attribute in attributes -%><% unless attribute.name =~ /_id/ || [:datetime, :timestamp, :time, :date].index(attribute.type) -%>
    response.should_have_tag '<%= attribute.input_type -%>', :attributes =>{:name => '<%= file_name %>[<%= attribute.name %>]'}<% end -%><% end -%>
  end
end


