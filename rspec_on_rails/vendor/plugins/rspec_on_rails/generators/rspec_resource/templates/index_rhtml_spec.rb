require File.dirname(__FILE__) + '/../../spec_helper'

context "/<%= table_name %>/index.rhtml" do
  include <%= controller_class_name %>Helper
  
  setup do<% [98,99].each do |id| -%>
    <%= file_name %>_<%= id %> = mock("<%= file_name %>_<%= id %>")
    <%= file_name %>_<%= id %>.stub!(:to_param).and_return(<%= id %>)<% for attribute in attributes -%>
    <%= file_name %>_<%= id %>.should_receive(:<%= attribute.name %>).and_return(<%= attribute.default_value %>)<% end -%>
<% end %>
    assigns[:<%= table_name %>] = [<%= file_name %>_98, <%= file_name %>_99]
  end

  specify "should render list of <%= table_name %>" do
    render "/<%= table_name %>/index.rhtml"
<% for attribute in attributes -%><% unless attribute.name =~ /_id/ || [:datetime, :timestamp, :time, :date].index(attribute.type) -%>
    response.should_have_tag 'td', :content => <%= attribute.default_value %><% end -%><% end -%>
  end
end

