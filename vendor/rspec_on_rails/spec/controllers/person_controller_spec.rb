require File.dirname(__FILE__) + '/../spec_helper'

context "The PersonController" do
  controller_name :person

  specify "should be a PersonController" do
    controller.should_be_instance_of PersonController
  end

  specify "should create an unsaved person record on GET to create" do
    person = mock("person")
    Person.should_receive(:new).and_return(person)
    controller.should_render :template => "person/create"
    get 'create'
    assigns[:person].should_be person
  end
  
  specify "should persist a new person and redirect to index on POST to create" do
    Person.should_receive(:create).with({"name" => 'Aslak'})
    controller.should_redirect_to :action => 'index'
    post 'create', {:person => {:name => 'Aslak'}}
    response.should_be_redirect
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
    get 'index'
    response.should_be_success
    assigns[:people].should_be @people
  end

end

context "/person/show/3" do
  controller_name :person
  
  setup do
    @person = mock("person")
  end
  
  specify "should get person with id => 3 from model (using partial mock)" do
    Person.should_receive(:find).with("3").and_return(@person)
    get 'show', :id => 3
  
    assigns[:person].should_be @person
  end
end
