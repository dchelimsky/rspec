require File.dirname(__FILE__) + '/../../spec_helper'

context "/<%= table_name %>/show.rhtml" do
  include <%= controller_class_name %>Helper
  
  setup do
    @<%= file_name %> = mock("<%= file_name %>")
    @<%= file_name %>.stub!(:to_param).and_return(99)
    @<%= file_name %>.stub!(:errors).and_return(@errors)<% for attribute in attributes -%>
    @<%= file_name %>.should_receive(:<%= attribute.name %>).and_return(<%= attribute.default_value %>)<% end -%>

    assigns[:<%= file_name %>] = @<%= file_name %>
  end

  specify "should render attributes in <p>" do
    render "/<%= table_name %>/show.rhtml"
<% for attribute in attributes -%><% unless attribute.name =~ /_id/ || [:datetime, :timestamp, :time, :date].index(attribute.type) -%>
    # response.should_have_tag('p', :content => <%= attribute.default_value %><% end -%><% end -%>)
  end
end

