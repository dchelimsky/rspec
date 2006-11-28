require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the <%= controller_class_name %>Controller should map" do
  controller_name :<%= table_name %>

  specify "{ :controller => '<%= table_name %>', :action => 'index' } to /<%= table_name %>" do
    route_for(:controller => "<%= table_name %>", :action => "index").should_eql "/<%= table_name %>"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'new' } to /<%= table_name %>/new" do
    route_for(:controller => "<%= table_name %>", :action => "new").should_eql "/<%= table_name %>/new"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'show', :id => 1 } to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "show", :id => 1).should_eql "/<%= table_name %>/1"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'edit', :id => 1 } to /<%= table_name %>/1;edit" do
    route_for(:controller => "<%= table_name %>", :action => "edit", :id => 1).should_eql "/<%= table_name %>/1;edit"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'update', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "update", :id => 1).should_eql "/<%= table_name %>/1"
  end
  
  specify "{ :controller => '<%= table_name %>', :action => 'destroy', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "destroy", :id => 1).should_eql "/<%= table_name %>/1"
  end
end

context "Requesting /<%= table_name %> using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= table_name %> = mock('<%= table_name %>')
    <%= class_name %>.stub!(:find).and_return(@mock_<%= table_name %>)
  end
  
  def do_get
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should render index.rhtml" do
    controller.should_render :index
    do_get
  end
  
  specify "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return(@mock_<%= table_name %>)
    do_get
  end
  
  specify "should assign the found <%= table_name %> for the view" do
    do_get
    assigns[:<%= table_name %>].should_be @mock_<%= table_name %>
    
  end
end

context "Requesting /<%= table_name %>.xml using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= table_name %> = mock('<%= table_name %>')
    @mock_<%= table_name %>.stub!(:to_xml).and_return("XML")
    <%= class_name %>.stub!(:find).and_return(@mock_<%= table_name %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  specify "should be successful" do
    do_get
    response.should_be_success
  end

  specify "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return(@mock_<%= table_name %>)
    do_get
  end
  
  specify "should render the found <%= table_name %> as xml" do
    @mock_<%= table_name %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /<%= table_name %>/1 using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>')
    <%= class_name %>.stub!(:find).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_get
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render show.rhtml" do
    controller.should_render :show
    do_get
  end
  
  specify "should find the <%= class_name.underscore %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@mock_<%= class_name.underscore %>)
    do_get
  end
  
  specify "should assign the found <%= class_name.underscore %> for the view" do
    do_get
    assigns[:<%= class_name.underscore %>].should_be @mock_<%= class_name.underscore %>
  end
end

context "Requesting /<%= table_name %>/1.xml using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>')
    @mock_<%= class_name.underscore %>.stub!(:to_xml).and_return("XML")
    <%= class_name %>.stub!(:find).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should find the <%= class_name.underscore %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@mock_<%= class_name.underscore %>)
    do_get
  end
  
  specify "should render the found <%= class_name.underscore %> as xml" do
    @mock_<%= class_name.underscore %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should_eql "XML"
  end
end

context "Requesting /<%= table_name %>/new using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>')
    <%= class_name %>.stub!(:new).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_get
    get :new
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render new.rhtml" do
    controller.should_render :new
    do_get
  end
  
  specify "should create an new <%= class_name.underscore %>" do
    <%= class_name %>.should_receive(:new).and_return(@mock_<%= class_name.underscore %>)
    do_get
  end
  
  specify "should not save the new <%= class_name.underscore %>" do
    @mock_<%= class_name.underscore %>.should_not_receive(:save)
    do_get
  end
  
  specify "should assign the new <%= class_name.underscore %> for the view" do
    do_get
    assigns[:<%= class_name.underscore %>].should_be @mock_<%= class_name.underscore %>
  end
end

context "Requesting /<%= table_name %>/1;edit using GET" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>')
    <%= class_name %>.stub!(:find).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  specify "should be successful" do
    do_get
    response.should_be_success
  end
  
  specify "should render edit.rhtml" do
    do_get
    controller.should_render :edit
  end
  
  specify "should find the <%= class_name.underscore %> requested" do
    <%= class_name %>.should_receive(:find).and_return(@mock_<%= class_name.underscore %>)
    do_get
  end
  
  specify "should assign the found <%= class_name %> for the view" do
    do_get
    assigns(:<%= class_name.underscore %>).should_equal @mock_<%= class_name.underscore %>
  end
end

context "Requesting /<%= table_name %> using POST" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>')
    @mock_<%= class_name.underscore %>.stub!(:save).and_return(true)
    @mock_<%= class_name.underscore %>.stub!(:to_param).and_return(1)
    <%= class_name %>.stub!(:new).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_post
    post :create, :<%= class_name.underscore %> => {:name => '<%= class_name %>'}
  end
  
  specify "should create a new <%= class_name.underscore %>" do
    <%= class_name %>.should_receive(:new).with({'name' => '<%= class_name %>'}).and_return(@mock_<%= class_name.underscore %>)
    do_post
  end

  specify "should redirect to the new <%= class_name.underscore %>" do
    do_post
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/<%= table_name %>/1"
  end
end

context "Requesting /<%= table_name %>/1 using PUT" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>', :null_object => true)
    @mock_<%= class_name.underscore %>.stub!(:to_param).and_return(1)
    <%= class_name %>.stub!(:find).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  specify "should find the <%= class_name.underscore %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@mock_<%= class_name.underscore %>)
    do_update
  end

  specify "should update the found <%= class_name.underscore %>" do
    @mock_<%= class_name.underscore %>.should_receive(:update_attributes)
    do_update
    assigns(:<%= class_name.underscore %>).should_be @mock_<%= class_name.underscore %>
  end

  specify "should assign the found <%= class_name.underscore %> for the view" do
    do_update
    assigns(:<%= class_name.underscore %>).should_be @mock_<%= class_name.underscore %>
  end

  specify "should redirect to the <%= class_name.underscore %>" do
    do_update
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/<%= table_name %>/1"
  end
end

context "Requesting /<%= table_name %>/1 using DELETE" do
  controller_name :<%= table_name %>

  setup do
    @mock_<%= class_name.underscore %> = mock('<%= class_name %>', :null_object => true)
    <%= class_name %>.stub!(:find).and_return(@mock_<%= class_name.underscore %>)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  specify "should find the <%= class_name.underscore %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@mock_<%= class_name.underscore %>)
    do_delete
  end
  
  specify "should call destroy on the found <%= class_name.underscore %>" do
    @mock_<%= class_name.underscore %>.should_receive(:destroy)
    do_delete
  end
  
  specify "should redirect to the <%= table_name %> list" do
    do_delete
    response.should_be_redirect
    response.redirect_url.should_eql "http://test.host/<%= table_name %>"
  end
end