require File.dirname(__FILE__) + '/../spec_helper'

context "Google's search page" do
  context_setup do
    @browser = Watir::Browser.new
  end
  
  setup do
    @browser.goto('http://www.google.com')
  end

  specify "should find rspec's home page when I search for rspec" do
    @browser.text_field(:name, "q").set("rspec")
    @browser.button(:name, "btnG").click
    @browser.should have_link(:url, "http://rspec.rubyforge.org/")
  end

  specify "should find rspec's home page when I search for 'better than fudge' (this is supposed to fail)" do
    @browser.text_field(:name, "q").set("better than fudge")
    @browser.button(:name, "btnG").click
    @browser.should have_link(:url, "http://rspec.rubyforge.org/")
  end

  specify "should not find Ali G when I search for respec" do
    @browser.text_field(:name, "q").set("respec")
    @browser.button(:name, "btnG").click
    @browser.should_not have_text("Ali G")
  end

  teardown do
    save_screenshot_and_source(@browser)
  end

  context_teardown do
    @browser.kill! rescue nil
  end
end