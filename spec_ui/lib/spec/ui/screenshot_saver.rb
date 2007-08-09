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
                e.message << <<-EOM
This is a bug in win32screenshot - it fails to take screenshots of "small" windows. Try this workaround:

1) Close all instances of the app you're trying to take a screenshot of (e.g. Internet Explorer)
2) Open the app
3) Resize the window so it occupies the entire screen (without maximizing it!)
4) Exit the app. Windows will now remember its size the next time it starts.

This *may* make this error go away
EOM
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
