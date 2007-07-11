# You don't need to tweak the $LOAD_PATH if you have RSpec and Spec::Ui installed as gems
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../rspec/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../lib')

require 'rubygems'
require 'spec'
require 'spec/ui'
require File.dirname(__FILE__) + '/selenium'
require 'spec/ui/selenium'

Spec::Runner.configure do |config|
  
  config.before(:all) do
    @browser = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://www.google.no", 10000)
    @browser.start
  end
  
  config.after(:each) do
    Spec::Ui::ScreenshotFormatter.instance.take_screenshot_of(@browser)
  end

  config.after(:all) do
    @browser.kill! rescue nil
  end
end
  
