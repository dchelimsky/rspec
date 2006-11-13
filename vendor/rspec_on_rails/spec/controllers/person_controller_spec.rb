# The comments below are here for educational purposes only.
# They are not an endorsement of comments in your spec!

require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  controller_name "person"
  
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
    assigns[:person].should_be @person
  end
  
  specify "should render 'person/create' on GET to create" do
    controller.should_render :template => "person/create"
    get 'create'
  end
  
  specify "should tell the Person model to create a new person on POST to create" do
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    
    post 'create', {:person => {:name => 'Aslak'}}
  end
  
  specify "with a valid person should redirect to index on successful POST to create" do
    @person.should_receive(:new_record?).and_return(false)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    controller.should_redirect_to :action => 'index'
    
    post 'create', {:person => {:name => 'Aslak'}}
    
    response.should_be_redirect
  end
  
  specify "with a valid person re-render 'person/create' on failed POST to create" do
    @person.should_receive(:new_record?).and_return(true)
    Person.should_receive(:create).with({"name" => 'Aslak'}).and_return(@person)
    controller.should_render :template => "person/create"
    
    post 'create', {:person => {:name => 'Aslak'}}
    
    response.should_not_be_redirect
    assigns[:person].should == Person.new({:name => 'Aslak'})
  end
end

context "When requesting /person with controller isolated from views" do
  controller_name :person

  setup do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end

  specify "the response should render 'list'" do
    controller.should_have_rendered :template => "person/list"
  end

  specify "should find all people on GET to index" do
    get 'index'
    assigns[:people].should_be @people
  end

end

context "When requesting /person with views integrated" do
  controller_name :person
  integrate_views

  setup do
    @mock_person = mock("person")
    @mock_person.stub!(:name).and_return("Joe")
    @people = [@mock_person]
    Person.stub!(:find).and_return(@people)
    get 'index'
  end
  
  specify "the response should render 'list'" do
    controller.should_have_rendered :template => "person/list"
  end

  specify "the response should not render 'index'" do
    lambda {
      controller.should_have_rendered :template => "person/index"
    }.should_raise
  end

  specify "should find all people on GET to index" do
    response.should_be_success
    assigns[:people].should_be @people
  end

end

context "/person/show/3" do
  controller_name :person
  
  setup do
    @person = mock("person")
  end
  
  specify "should get person with id => 3 from model" do
    Person.should_receive(:find).with("3").and_return(@person)
    
    get 'show', :id => 3
  
    assigns[:person].should_be @person
  end
end