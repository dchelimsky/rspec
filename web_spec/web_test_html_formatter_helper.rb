require 'rubygems'
require 'RMagick'

# include this module in your spec and call +save_screenshot+ and +save_source+ from
# teardown.
module WebTestHtmlFormatterHelper
  if RUBY_PLATFORM =~ /darwin/
    require File.dirname(__FILE__) + '/web_test_html_formatter_osx_helper'
    include WebTestHtmlFormatterOsxHelper
    Watir::Browser = Watir::Safari
  else
    require File.dirname(__FILE__) + '/web_test_html_formatter_win_helper'
    include WebTestHtmlFormatterWinHelper
    Watir::Browser = Watir::IE
  end

  def save_thumb(img, dir, spec_number)
    thumb = img.scale(0.25)
    thumb_file = "#{dir}/#{spec_number}_thumb.png"
    thumb.write(thumb_file)
  end

  def save_source(dir, spec_number, html)
    File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
  end
end
