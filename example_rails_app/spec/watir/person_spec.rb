require 'spec/ui/watir_helper'

context "Person Webpage" do
  # TODO: Get this to work with Fixtures
  
  context_setup do
    # This will be Watir::IE or Watir::Safari depending on your OS.
    @browser = Watir::Browser.new
  end
  
  specify "should display create field" do
    @browser.goto("http://localhost:3000/people/create")
    @browser.text_field(:id, "person_name").set("Some name")
    @browser.button(:name, "commit").click
    @browser.should_contain_text("Some names")
  end
end