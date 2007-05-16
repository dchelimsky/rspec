require File.dirname(__FILE__) + '/../spec_helper'

describe "Google's search page" do
  before(:each) do
    # The @browser is initialised in spec_helper.rb
    @browser.goto('http://www.google.com')
  end

  it "should find rspec's home page when I search for rspec" do
    @browser.text_field(:name, "q").set("rspec")
    @browser.button(:name, "btnG").click
    @browser.should have_link(:url, "http://rspec.rubyforge.org/")
  end

  it "should find rspec's home page when I search for 'better than fudge' (this is supposed to fail)" do
    @browser.text_field(:name, "q").set("better than fudge")
    @browser.button(:name, "btnG").click
    @browser.should have_link(:url, "http://rspec.rubyforge.org/")
  end

  it "should not find Ali G when I search for respec" do
    @browser.text_field(:name, "q").set("respec")
    @browser.button(:name, "btnG").click
    @browser.should_not have_text("Ali G")
  end
end