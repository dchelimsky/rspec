require 'fileutils'

module Spec
  module Ui
    module ScreenshotSaver
      if RUBY_PLATFORM =~ /darwin/
        def save_screenshot(png_path)
          # How do we capture the current window??
          `screencapture #{png_path}`
        end
      else # Win32
        begin
          # TODO: Move all this code to win32screenshot
          require 'rubygems'
          require 'RMagick'
          gem 'win32screenshot', '>=0.0.2'
          require 'win32screenshot'
          def save_screenshot(png_path)
            width, height, bmp = ::Win32::Screenshot.foreground
            begin
              img = Magick::Image.from_blob(bmp)[0]
              img.write(png_path)
              nil
            rescue Magick::ImageMagickError => e
              if e.message =~ /Insufficient image data in file/
                e.message << "\nTry this:\n1) Open your app (e.g. Internet Explorer)\n2) Resize the app to be bigger (without maximizing).\n3) close it so Windows remembers its size.\n" +
                "This *may* make this error go away."
              end
              raise e
            end
          end
        rescue Gem::LoadError => e
          def save_screenshot(png_path)
            FileUtils.cp(File.dirname(__FILE__) + '/images/wrong_win32screenshot.png', png_path)
          end
        rescue LoadError => e
          if(e.message =~ /win32screenshot/)
            def save_screenshot(png_path)
              FileUtils.cp(File.dirname(__FILE__) + '/images/win32screenshot_not_installed.png', png_path)
            end
          else
            def save_screenshot(png_path)
              FileUtils.cp(File.dirname(__FILE__) + '/images/rmagick_not_installed.png', png_path)
            end
          end
        end
      end
    end
  end
end