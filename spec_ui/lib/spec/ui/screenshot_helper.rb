module Spec
  module Ui
    module ScreenshotHelper
      if RUBY_PLATFORM =~ /darwin/
        def save_screenshot(dir, spec_number)
          img_path = "#{dir}/#{spec_number}.png"
          # How do we capture the current window??
          `screencapture #{img_path}`
        end
      else
        begin
          require 'rubygems'
          require 'RMagick'
          def save_screenshot(dir, spec_number)
            width, height, bmp = Win32::Screenshot.foreground
            img = Magick::Image.from_blob(bmp)[0]
            img_path = "#{dir}/#{spec_number}.png"
            img.write(img_path)
            img
          end
        rescue LoadError
          require 'fileutils'
          def save_screenshot(dir, spec_number)
            FileUtils.cp(File.dirname(__FILE__) + '/rmagick_not_installed.png', "#{dir}/#{spec_number}.png")
          end
        end
      end
    end
  end
end