# The comments below are here for educational purposes only.
# They are not an endorsement of comments in your spec!

require File.dirname(__FILE__) + '/../spec_helper'

describe PeopleController do
  # If you pass the controller to #describe, you don't need to declare the controller name
  
  before(:each) do
    @person = mock("person")
    
    # Generally, prefer stub! over should_receive in setup.
    @person.stub!(:new_record?).and_return(false)
    Person.stub!(:new).and_return(@person)
  end
  
  it "should create a new, unsaved person on GET to create" do
    # Using should_receive here overrides the stub in setup. Even
    # though it is the same as the stub, using should_receive sets
    # an expectation that  will be verified. It also helps to
    # better express the intent of this example.
    Person.should_receive(:new).and_return(@person)
    get 'create'
  end
  
  it "should assign new person to template on GET to create" do
    get 'create'
    assigns[:person].should equal(@person)
  end
  
  it "should render 'people/create' on GET to create" do
    get 'create'
    response.should render_template(:create)
  end
  
  it "should tell the Person model to create a new person on POST to create" do
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}
  end
  
  it "with a valid person should redirect to index on successful POST to create" do
    @person.should_receive(:new_record?).and_return(false)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}

    response.should redirect_to(:action => 'index')
  end
  
  it "with a valid person should re-render 'people/create' on failed POST to create" do
    @person.should_receive(:new_record?).and_return(true)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}
    
    response.should render_template("people/create")
    response.should_not be_redirect
    assigns[:person].should == Person.new({:name => 'Aslak'})
  end
end

describe "When requesting /people with controller isolated from views" do
  # If you do not pass the controller to #describe, you need to declare the controller name
  controller_name :people

  before(:each) do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end

  it "the response should render 'list'" do
    response.should render_template(:list)
  end

  it "should find all people on GET to index" do
    assigns[:people].should equal(@people)
  end

end

describe "When requesting /people with views integrated" do
  controller_name :people
  integrate_views

  before(:each) do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end
  
  it "the response should render 'list'" do
    response.should render_template(:list)
  end

  it "the response should not render 'index'" do
    lambda {
      response.should render_template(:index)
    }.should raise_error
  end

  it "should find all people on GET to index" do
    response.should be_success
    assigns[:people].should equal(@people)
  end
  
  it "should list pets on GET to show" do
    person = mock("person")
    person.should_receive(:pets).and_return([OpenStruct.new(:name => 'Hannibal'), OpenStruct.new(:name => 'Rufus')])
    Person.should_receive(:find).with('4').and_return(person)

    get 'show', :id => '4'
    response.should have_tag('li', 'Hannibal')
    response.should have_tag('li', 'Rufus')
  end
end

describe "/people/show/3" do
  controller_name :people
  
  before(:each) do
    @person = mock("person")
  end
  
  it "should get person with id => 3 from model" do
    Person.should_receive(:find).with("3").and_return(@person)
    
    get 'show', :id => 3
  
    assigns[:person].should equal(@person)
  end
end

describe "Given an attempt to show a person that doesn't exist" do
  controller_name :people
  
  before(:each) do
    Person.stub!(:find)
    get 'show', :id => 'broken'
  end

  it "should not assign a person" do
    assigns[:person].should == nil
  end

  it "should render 404 file" do
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should == "404 Not Found"
  end
end