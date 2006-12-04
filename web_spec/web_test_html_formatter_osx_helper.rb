require 'rubygems'
require 'safariwatir'

module WebTestHtmlFormatterOsxHelper  
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