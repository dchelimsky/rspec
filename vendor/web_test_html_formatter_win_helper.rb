require 'rubygems'
require 'win32screenshot'
require 'watir'
require File.dirname(__FILE__) + '/web_test_html_formatter_helper'

# include this module in your spec and call +save_screenshot+ and +save_source+ from
# teardown.
module WebTestHtmlFormatterWinHelper
  include WebTestHtmlFormatterHelper

  def save_screenshots(dir, spec_number)
    width, height, bmp = Win32::Screenshot.foreground

    img = Magick::Image.from_blob(bmp)[0]
    img_path = "#{dir}/#{spec_number}.png"
    img.write(img_path)
    save_thumb(img, dir, spec_number)
  end
end