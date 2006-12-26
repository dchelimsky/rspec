require File.dirname(__FILE__) + '/rspec_selenium'

context "Google's search page" do

  setup do
    @browser.open('http://www.google.no')
  end

  specify "should find rspec's home page when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("rspec.rubyforge.org").should_be(true)
  end

  specify "should not find Ali G when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("Ali G").should_be(false)
  end

end