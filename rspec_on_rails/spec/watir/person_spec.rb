require 'spec/ui/watir_helper'

context "Person Webpage" do
  context_setup do
    # This will be Watir::IE or Watir::Safari depending on your OS.
    @browser = Watir::Browser.new
  end
  
  specify "should display create field" do
    @browser.goto("http://localhost:3000/person/create")
    name = "Something Else"
    @browser.text_field(:id, "person_name").set(name)
    @browser.button(:name, "commit").click
  end
end