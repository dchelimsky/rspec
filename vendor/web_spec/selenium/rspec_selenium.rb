require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/selenium'

class RSpecSelenium
  def teardown
    @browser.stop
  end
end

module Spec
  module Runner
    class Context
      def before_context_eval
        inherit RSpecSelenium
      end
    end
  end
end

module Selenium
  class SeleneseInterpreter
    def click_and_wait(locator, timeout="5000")
      click(locator)
      wait_for_page_to_load timeout
    end

    def open_and_wait(url, timeout="5000")
      open(url)
      wait_for_page_to_load timeout
    end
  end
end
