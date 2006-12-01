require 'rubygems'
require 'safariwatir'
require File.dirname(__FILE__) + '/web_test_html_formatter_helper'

# include this module in your spec and call +save_screenshot+ and +save_source+ from
# teardown.
module WebTestHtmlFormatterOsxHelper
  include WebTestHtmlFormatterHelper
  
  def save_screenshots(dir, spec_number)
    img_path = "#{dir}/#{spec_number}.png"
    # How do we capture the current window??
    `screencapture #{img_path}`

    img = Magick::Image.read(img_path)[0]
    save_thumb(img, dir, spec_number)
  end
end

class Watir::AppleScripter
  def document_html
    execute(%|document.documentElement.innerHTML;|)
  end
end