=begin
$LOAD_PATH.unshift(File.expand_path(File.join(RAILS_ROOT, '..', 'spec_ui', 'lib')))
require 'spec/ui/watir_helper'

describe "Person Webpage" do
  # TODO: Get this to work with Fixtures
  
  context_setup do
    # This will be Watir::IE or Watir::Safari depending on your OS.
    @browser = Watir::Browser.new
  end
  
  it "should display create field" do
    @browser.goto("http://localhost:3000/people/create")
    @browser.text_field(:id, "person_name").set("Some name")
    @browser.button(:name, "commit").click
    @browser.should be_contain_text("Some names")
  end
end
=end