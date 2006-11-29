require File.dirname(__FILE__) + '/rspec_watir'

context "Google's search page" do

  setup do
    @browser.goto('http://www.google.com')
  end

  specify "should find rspec's home page when I search for rspec" do
    @browser.text_field(:name, "q").set("rspec")
    @browser.button(:name, "btnG").click
    @browser.should_contain("rspec.rubyforge.org") # should_contain_text is RSpec sugar
  end

  specify "should find rspec's home page when I search for 'better than fudge' (will probably fail)" do
    @browser.text_field(:name, "q").set("better than fudge")
    @browser.button(:name, "btnG").click
    @browser.should_contain("rspec.rubyforge.org")
  end

  specify "should not find Ali G when I search for respec" do
    @browser.text_field(:name, "q").set("respec")
    @browser.button(:name, "btnG").click
    @browser.should_not_contain("Ali G")
  end

end