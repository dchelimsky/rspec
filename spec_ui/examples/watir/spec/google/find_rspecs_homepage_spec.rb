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
    @browser.contains_text("rspec.rubyforge.org").should_not_be nil # should_contain_text is RSpec sugar
  end

  specify "should find rspec's home page when I search for 'better than fudge' (will probably fail)" do
    @browser.text_field(:name, "q").set("better than fudge")
    @browser.button(:name, "btnG").click
    @browser.contains_text("rspec.rubyforge.org").should_not_be nil
  end

  specify "should not find Ali G when I search for respec" do
    @browser.text_field(:name, "q").set("respec")
    @browser.button(:name, "btnG").click
    @browser.contains_text("Ali G").should_be nil
  end
end