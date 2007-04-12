module Selenium
  class SeleniumDriver
    def click_and_wait(locator, timeout="5000")
      click(locator)
      wait_for_page_to_load(timeout)
    end

    def open_and_wait(url, timeout="5000")
      open(url)
      wait_for_page_to_load(timeout)
    end

    def html
      get_html_source
    end
    
    def kill!
      stop
    end
  end
end
