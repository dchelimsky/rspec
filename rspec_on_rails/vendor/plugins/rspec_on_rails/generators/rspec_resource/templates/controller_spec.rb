require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the <%= controller_class_name %>Controller should map" do
  controller_name :<%= table_name %>

  specify "{ :controller => '<%= table_name %>', :action => 'index' } to /<%= table_name %>" do
    route_for(:controller => "<%= table_name %>", :action => "index").should == "/<%= table_name %>"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'new' } to /<%= table_name %>/new" do
    route_for(:controller => "<%= table_name %>", :action => "new").should == "/<%= table_name %>/new"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'show', :id => 1 } to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "show", :id => 1).should == "/<%= table_name %>/1"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'edit', :id => 1 } to /<%= table_name %>/1;edit" do
    route_for(:controller => "<%= table_name %>", :action => "edit", :id => 1).should == "/<%= table_name %>/1;edit"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'update', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "update", :id => 1).should == "/<%= table_name %>/1"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'destroy', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "destroy", :id => 1).should == "/<%= table_name %>/1"
  end
end

context "Requesting /<%= table_name %> using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return([@<%= file_name %>])
  end
  
  def do_get
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should render index.rhtml" do
    do_get
    response.should render_template('index')
  end
  
  specify "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return([@<%= file_name %>])
    do_get
  end
  
  specify "should assign the found <%= table_name %> for the view" do
    do_get
    assigns[:<%= table_name %>].should == [@<%= file_name %>]
  end
end

context "Requesting /<%= table_name %>.xml using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_xml => "XML")
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should be_success
  end

  specify "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return([@<%= file_name %>])
    do_get
  end
  
  specify "should render the found <%= table_name %> as xml" do
    @<%= file_name %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /<%= table_name %>/1 using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render show.rhtml" do
    do_get
    response.should render_template('show')
  end
  
  specify "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_get
  end
  
  specify "should assign the found <%= file_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should equal(@<%= file_name %>)
  end
end

context "Requesting /<%= table_name %>/1.xml using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_xml => "XML")
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_get
  end
  
  specify "should render the found <%= file_name %> as xml" do
    @<%= file_name %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

context "Requesting /<%= table_name %>/new using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :new
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render new.rhtml" do
    do_get
    response.should render_template('new')
  end
  
  specify "should create an new <%= file_name %>" do
    <%= class_name %>.should_receive(:new).and_return(@<%= file_name %>)
    do_get
  end
  
  specify "should not save the new <%= file_name %>" do
    @<%= file_name %>.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new <%= file_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should be(@<%= file_name %>)
  end
end

context "Requesting /<%= table_name %>/1;edit using GET" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    response.should render_template('edit')
  end
  
  specify "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).and_return(@<%= file_name %>)
    do_get
  end
  
  specify "should assign the found <%= class_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should equal(@<%= file_name %>)
  end
end

context "Requesting /<%= table_name %> using POST" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1", :save => true)
    <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
  end
  
  def do_post
    post :create, :<%= file_name %> => {:name => '<%= class_name %>'}
  end
  
  specify "should create a new <%= file_name %>" do
    <%= class_name %>.should_receive(:new).with({'name' => '<%= class_name %>'}).and_return(@<%= file_name %>)
    do_post
  end

  specify "should redirect to the new <%= file_name %>" do
    do_post
    response.should redirect_to(<%= table_name.singularize %>_url("1"))
  end
end

context "Requesting /<%= table_name %>/1 using PUT" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1", :update_attributes => true)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_update
  end

  specify "should update the found <%= file_name %>" do
    @<%= file_name %>.should_receive(:update_attributes)
    do_update
    assigns(:<%= file_name %>).should equal(@<%= file_name %>)
  end

  specify "should assign the found <%= file_name %> for the view" do
    do_update
    assigns(:<%= file_name %>).should equal(@<%= file_name %>)
  end

  specify "should redirect to the <%= file_name %>" do
    do_update
    response.should redirect_to(<%= table_name.singularize %>_url("1"))
  end
end

context "Requesting /<%= table_name %>/1 using DELETE" do
  controller_name :<%= table_name %>

  setup do
    @<%= file_name %> = mock_model(<%= class_name %>, :destroy => true)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_delete
  end
  
  specify "should call destroy on the found <%= file_name %>" do
    @<%= file_name %>.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the <%= table_name %> list" do
    do_delete
    response.should redirect_to(<%= table_name %>_url)
  end
end