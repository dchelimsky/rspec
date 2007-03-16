# The comments below are here for educational purposes only.
# They are not an endorsement of comments in your spec!

require File.dirname(__FILE__) + '/../spec_helper'

context PeopleController do
  controller_name "people"
  
  setup do
    @person = mock("person")
    
    # Generally, prefer stub! over should_receive in setup.
    @person.stub!(:new_record?).and_return(false)
    Person.stub!(:new).and_return(@person)
  end
  
  specify "should create a new, unsaved person on GET to create" do
    # Using should_receive here overrides the stub in setup. Even
    # though it is the same as the stub, using should_receive sets
    # an expectation that  will be verified. It also helps to
    # better express the intent of this spec block.
    Person.should_receive(:new).and_return(@person)
    get 'create'
  end
  
  specify "should assign new person to template on GET to create" do
    get 'create'
    assigns[:person].should equal(@person)
  end
  
  specify "should render 'people/create' on GET to create" do
    get 'create'
    response.should render_template(:create)
  end
  
  specify "should tell the Person model to create a new person on POST to create" do
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}
  end
  
  specify "with a valid person should redirect to index on successful POST to create" do
    @person.should_receive(:new_record?).and_return(false)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}

    response.should redirect_to(:action => 'index')
  end
  
  specify "with a valid person re-render 'people/create' on failed POST to create" do
    @person.should_receive(:new_record?).and_return(true)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}
    
    response.should render_template("people/create")
    response.should_not be_redirect
    assigns[:person].should == Person.new({:name => 'Aslak'})
  end
end

context "When requesting /people with controller isolated from views" do
  controller_name :people

  setup do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end

  specify "the response should render 'list'" do
    response.should render_template(:list)
  end

  specify "should find all people on GET to index" do
    get 'index'
    assigns[:people].should equal(@people)
  end

end

context "When requesting /people with views integrated" do
  controller_name :people
  integrate_views

  setup do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end
  
  specify "the response should render 'list'" do
    response.should render_template(:list)
  end

  specify "the response should not render 'index'" do
    lambda {
      response.should render_template(:index)
    }.should raise_error
  end

  specify "should find all people on GET to index" do
    response.should be_success
    assigns[:people].should equal(@people)
  end
  
  specify "should list pets on GET to show" do
    person = mock("person")
    person.should_receive(:pets).and_return([OpenStruct.new(:name => 'Hannibal'), OpenStruct.new(:name => 'Rufus')])
    Person.should_receive(:find).with('4').and_return(person)

    get 'show', :id => '4'
    response.should have_tag('li', 'Hannibal')
    response.should have_tag('li', 'Rufus')
  end
end

context "/people/show/3" do
  controller_name :people
  
  setup do
    @person = mock("person")
  end
  
  specify "should get person with id => 3 from model" do
    Person.should_receive(:find).with("3").and_return(@person)
    
    get 'show', :id => 3
  
    assigns[:person].should equal(@person)
  end
end

context "Given an attempt to show a person that doesn't exist" do
  controller_name :people
  
  setup do
    Person.stub!(:find)
  end

  specify "should not assign a person" do
    get 'show', :id => 'broken'
    assigns[:person].should == nil
  end

  specify "should render 404 file" do
    get 'show', :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should == "404 Not Found"
  end
end