require File.dirname(__FILE__) + '/../spec_helper'

context "Google's search page" do
  context_setup do
    @browser = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://www.google.no", 10000)
    @browser.start
  end
    
  setup do
    @browser.open('http://www.google.no')
  end

  specify "should find rspec's home page when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("rspec.rubyforge.org").should_be(true)
  end

  specify "should find rspec's home page when I search for 'better than fudge' (will probably fail)" do
    @browser.type "name=q", "better than fudge"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("rspec.rubyforge.org").should_be(true)
  end

  specify "should not find Ali G when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("Ali G").should_be(false)
  end

  teardown do
    save_screenshot_and_source(@browser)
  end

  context_teardown do
    @browser.kill! rescue nil
  end
end