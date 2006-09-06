require File.dirname(__FILE__) + '/rspec_watir'

context "Google's search page" do

  setup do
    @browser.goto('http://www.google.com')
  end

  specify "should find rspec's home page" do
    @browser.text_field(:name, "q").set("rspec")
    @browser.button(:name, "btnG").click
    @browser.contains_text("rspec.rubyforge.org").should_be(true)
  end

  specify "should not find Ali G when I search for rspec" do
    @browser.text_field(:name, "q").set("rspec")
    @browser.button(:name, "btnG").click
    # You should change this if you're not in Norway!
    @browser.contains_text("Ali G").should_be(false)
  end

end