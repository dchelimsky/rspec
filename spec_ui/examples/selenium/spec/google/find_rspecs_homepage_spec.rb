require File.dirname(__FILE__) + '/../spec_helper'

describe "Google's search page" do

  before(:each) do
    # The @browser is initialised in spec_helper.rb
    @browser.open('http://www.google.no')
  end

  it "should find rspec's home page when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("rspec.rubyforge.org").should be_true
  end

  it "should find rspec's home page when I search for 'better than fudge' (will probably fail)" do
    @browser.type "name=q", "better than fudge"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("rspec.rubyforge.org").should be_true
  end

  it "should not find Ali G when I search for rspec" do
    @browser.type "name=q", "rspec"
    @browser.click_and_wait "name=btnG"
    @browser.is_text_present("Ali G").should be_false
  end

end