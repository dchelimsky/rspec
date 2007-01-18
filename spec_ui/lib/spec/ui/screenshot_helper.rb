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
          require_gem 'win32screenshot', '>=0.0.3'
          require 'win32screenshot'
          def save_screenshot(dir, spec_number)
            width, height, bmp = ::Win32::Screenshot.foreground
            begin
              img = Magick::Image.from_blob(bmp)[0]
              img_path = "#{dir}/#{spec_number}.png"
              img.write(img_path)
              img
            rescue Magick::ImageMagickError => e
              if e.message =~ /Insufficient image data in file/
                e.message << "\nTry this:\n1) Open your app (e.g. Internet Explorer)\n2) Resize the app to be bigger (without maximizing).\n3) close it so Windows remembers its size.\n" +
                "This *may* make this error go away."
              end
              raise e
            end
          end
        rescue Gem::LoadError => e
          require 'fileutils'
          def save_screenshot(dir, spec_number)
            FileUtils.cp(File.dirname(__FILE__) + '/wrong_win32screenshot.png', "#{dir}/#{spec_number}.png")
          end
        rescue LoadError => e
          require 'fileutils'
          if(e.message =~ /win32screenshot/)
            def save_screenshot(dir, spec_number)
              FileUtils.cp(File.dirname(__FILE__) + '/win32screenshot_not_installed.png', "#{dir}/#{spec_number}.png")
            end
          else
            def save_screenshot(dir, spec_number)
              FileUtils.cp(File.dirname(__FILE__) + '/rmagick_not_installed.png', "#{dir}/#{spec_number}.png")
            end
          end
        end
      end
    end
  end
end