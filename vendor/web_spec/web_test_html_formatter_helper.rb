require 'rubygems'
require 'RMagick'

# include this module in your spec and call +save_screenshot+ and +save_source+ from
# teardown.
module WebTestHtmlFormatterHelper
  def save_thumb(img, dir, spec_number)
    thumb = img.scale(0.25)
    thumb_file = "#{dir}/#{spec_number}_thumb.png"
    thumb.write(thumb_file)
  end

  def save_source(dir, spec_number, html)
    File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
  end
end
