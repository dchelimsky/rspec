require File.join(File.dirname(__FILE__), "helper")

Story "Add Person", %{
  As an admin
  I want to add people to the system
  So that I show how many people use my system
}, :type => RailsStory do
  Scenario "Successfully add person" do
    Given "no people in the system" do
      Person.destroy_all
    end
    
    When "creating a new person named", "Dan" do |name|
      post "/people/create", :person => {:name => name}
    end
    
    Then "viewer should see", "/people/list" do |template|
      follow_redirect!
      response.should render_template(template)
    end
    
    Then "list should include", "Dan" do |name|
      response.should have_text(/#{name}/)
    end
  end
  
  Scenario "Redirect to create form on failed create" do
    Given "no people in the system" do
      Person.destroy_all
    end
    
    When "creating a new person with no name" do
#      post "/people/create", :person => {:name => nil}
      When "creating a new person named", nil
    end
    
    Then "viewer should see", "/people/create" do |template|
      assert_template template
    end
    
    Then "list should not include", "Dan" do |name|
      response.should_not have_text(/#{name}/)
    end
  end
end
