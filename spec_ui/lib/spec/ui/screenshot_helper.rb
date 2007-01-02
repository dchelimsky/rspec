require 'rubygems'
require 'RMagick'

module Spec
  module Ui
    module ScreenshotHelper
      if RUBY_PLATFORM =~ /darwin/
        def save_screenshot(dir, spec_number)
          img_path = "#{dir}/#{spec_number}.png"
          # How do we capture the current window??
          `screencapture #{img_path}`
          img = Magick::Image.read(img_path)[0]
        end
      else
        def save_screenshot(dir, spec_number)
          width, height, bmp = Win32::Screenshot.foreground
          img = Magick::Image.from_blob(bmp)[0]
          img_path = "#{dir}/#{spec_number}.png"
          img.write(img_path)
          img
        end
      end

      def save_screenshots(dir, spec_number)
        img = save_screenshot(dir, spec_number)
        save_thumb(img, dir, spec_number)
      end

      def save_thumb(img, dir, spec_number)
        thumb = img.scale(0.25)
        thumb_file = "#{dir}/#{spec_number}_thumb.png"
        thumb.write(thumb_file)
      end

    end
  end
end