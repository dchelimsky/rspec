require File.dirname(__FILE__) + '/../../spec_helper'

context "/<%= table_name %>/edit.rhtml" do
  include <%= controller_class_name %>Helper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @<%= file_name %> = mock("<%= file_name %>")
    @<%= file_name %>.stub!(:to_param).and_return(99)
    @<%= file_name %>.stub!(:errors).and_return(@errors)<% for attribute in attributes -%>
    @<%= file_name %>.should_receive(:<%= attribute.name %>).and_return(<%= attribute.default_value %>)<% end -%>

    assigns[:<%= file_name %>] = @<%= file_name %>
  end

  specify "should render edit form" do
    render "/<%= table_name %>/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => <%= file_name %>_path(@<%= file_name %>), :method => 'post'}
<% for attribute in attributes -%><% unless attribute.name =~ /_id/ || [:datetime, :timestamp, :time, :date].index(attribute.type) -%>
    response.should_have_tag 'input', :attributes =>{:name => '<%= file_name %>[<%= attribute.name %>]'}<% end -%><% end -%>
  end
end

