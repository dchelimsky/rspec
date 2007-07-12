# You don't need to tweak the $LOAD_PATH if you have RSpec and Spec::Ui installed as gems
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../rspec/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../lib')

require 'rubygems'
require 'spec'
require 'spec/ui'
require 'spec/ui/watir'

Spec::Runner.configure do |config|
  config.before(:all) do
    @browser = Watir::Browser.new
  end

  config.after(:each) do
    Spec::Ui::ScreenshotFormatter.instance.take_screenshot_of(@browser)
  end

  config.after(:all) do
    @browser.kill! unless RUBY_PLATFORM =~ /darwin/ # SafariWatir doesn't like closing and opening
  end
end
