require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

describe <%= controller_class_name %>Controller, "#route_for" do

  it "should map { :controller => '<%= table_name %>', :action => 'index' } to /<%= table_name %>" do
    route_for(:controller => "<%= table_name %>", :action => "index").should == "/<%= table_name %>"
  end
  
  it "should map { :controller => '<%= table_name %>', :action => 'new' } to /<%= table_name %>/new" do
    route_for(:controller => "<%= table_name %>", :action => "new").should == "/<%= table_name %>/new"
  end
  
  it "should map { :controller => '<%= table_name %>', :action => 'show', :id => 1 } to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "show", :id => 1).should == "/<%= table_name %>/1"
  end
  
  it "should map { :controller => '<%= table_name %>', :action => 'edit', :id => 1 } to /<%= table_name %>/1<%= resource_edit_path %>" do
    route_for(:controller => "<%= table_name %>", :action => "edit", :id => 1).should == "/<%= table_name %>/1<%= resource_edit_path %>"
  end
  
  it "should map { :controller => '<%= table_name %>', :action => 'update', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "update", :id => 1).should == "/<%= table_name %>/1"
  end
  
  it "should map { :controller => '<%= table_name %>', :action => 'destroy', :id => 1} to /<%= table_name %>/1" do
    route_for(:controller => "<%= table_name %>", :action => "destroy", :id => 1).should == "/<%= table_name %>/1"
  end
  
end

describe <%= controller_class_name %>Controller, "#params_from" do

  it "should generate params { :controller => '<%= table_name %>', action => 'index' } from GET /<%= table_name %>" do
    params_from(:get, "/<%= table_name %>").should == {:controller => "<%= table_name %>", :action => "index"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'new' } from GET /<%= table_name %>/new" do
    params_from(:get, "/<%= table_name %>/new").should == {:controller => "<%= table_name %>", :action => "new"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'create' } from POST /<%= table_name %>" do
    params_from(:post, "/<%= table_name %>").should == {:controller => "<%= table_name %>", :action => "create"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'show', id => '1' } from GET /<%= table_name %>/1" do
    params_from(:get, "/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "show", :id => "1"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'edit', id => '1' } from GET /<%= table_name %>/1;edit" do
    params_from(:get, "/<%= table_name %>/1<%= resource_edit_path %>").should == {:controller => "<%= table_name %>", :action => "edit", :id => "1"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'update', id => '1' } from PUT /<%= table_name %>/1" do
    params_from(:put, "/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "update", :id => "1"}
  end
  
  it "should generate params { :controller => '<%= table_name %>', action => 'destroy', id => '1' } from DELETE /<%= table_name %>/1" do
    params_from(:delete, "/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "destroy", :id => "1"}
  end
  
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return([@<%= file_name %>])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return([@<%= file_name %>])
    do_get
  end
  
  it "should assign the found <%= table_name %> for the view" do
    do_get
    assigns[:<%= table_name %>].should == [@<%= file_name %>]
  end
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>.xml" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_xml => "XML")
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all <%= table_name %>" do
    <%= class_name %>.should_receive(:find).with(:all).and_return([@<%= file_name %>])
    do_get
  end
  
  it "should render the found <%= table_name %> as xml" do
    @<%= file_name %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>/1" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_get
  end
  
  it "should assign the found <%= file_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should equal(@<%= file_name %>)
  end
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>/1.xml" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_xml => "XML")
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_get
  end
  
  it "should render the found <%= file_name %> as xml" do
    @<%= file_name %>.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>/new" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new <%= file_name %>" do
    <%= class_name %>.should_receive(:new).and_return(@<%= file_name %>)
    do_get
  end
  
  it "should not save the new <%= file_name %>" do
    @<%= file_name %>.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new <%= file_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should equal(@<%= file_name %>)
  end
end

describe <%= controller_class_name %>Controller, "handling GET /<%= table_name %>/1/edit" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).and_return(@<%= file_name %>)
    do_get
  end
  
  it "should assign the found <%= class_name %> for the view" do
    do_get
    assigns[:<%= file_name %>].should equal(@<%= file_name %>)
  end
end

describe <%= controller_class_name %>Controller, "handling POST /<%= table_name %>" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1")
    <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
  end
  
  def post_with_successful_save
    @<%= file_name %>.should_receive(:save).and_return(true)
    post :create, :<%= file_name %> => {}
  end
  
  def post_with_failed_save
    @<%= file_name %>.should_receive(:save).and_return(false)
    post :create, :<%= file_name %> => {}
  end
  
  it "should create a new <%= file_name %>" do
    <%= class_name %>.should_receive(:new).with({}).and_return(@<%= file_name %>)
    post_with_successful_save
  end

  it "should redirect to the new <%= file_name %> on successful save" do
    post_with_successful_save
    response.should redirect_to(<%= table_name.singularize %>_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe <%= controller_class_name %>Controller, "handling PUT /<%= table_name %>/1" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1")
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def put_with_successful_update
    @<%= file_name %>.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @<%= file_name %>.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    put_with_successful_update
  end

  it "should update the found <%= file_name %>" do
    put_with_successful_update
    assigns(:<%= file_name %>).should equal(@<%= file_name %>)
  end

  it "should assign the found <%= file_name %> for the view" do
    put_with_successful_update
    assigns(:<%= file_name %>).should equal(@<%= file_name %>)
  end

  it "should redirect to the <%= file_name %> on successful update" do
    put_with_successful_update
    response.should redirect_to(<%= table_name.singularize %>_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe <%= controller_class_name %>Controller, "handling DELETE /<%= table_name %>/1" do

  before do
    @<%= file_name %> = mock_model(<%= class_name %>, :destroy => true)
    <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the <%= file_name %> requested" do
    <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
    do_delete
  end
  
  it "should call destroy on the found <%= file_name %>" do
    @<%= file_name %>.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the <%= table_name %> list" do
    do_delete
    response.should redirect_to(<%= table_name %>_url)
  end
end
