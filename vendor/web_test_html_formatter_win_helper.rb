require 'rubygems'
require 'win32screenshot'
require 'RMagick'

# include this module in your spec and call +save_screenshot+ and +save_source+ from
# teardown.
module WebTestHtmlFormatterWinHelper
  def save_screenshot(dir, spec_number)
    width, height, bmp = Win32::Screenshot.foreground

    img = Magick::Image.from_blob(bmp)[0]
    thumb = img.scale(0.25)

    png = img.to_blob do
      self.format = 'PNG'
    end
    File.open("#{dir}/#{spec_number}.png", "wb") {|io| io.write(png)}

    thumb_png = thumb.to_blob do
      self.format = 'PNG'
    end
    File.open("#{dir}/#{spec_number}_thumb.png", "wb") {|io| io.write(thumb_png)}
  end

  def save_source(dir, spec_number, html)
    File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
  end

end