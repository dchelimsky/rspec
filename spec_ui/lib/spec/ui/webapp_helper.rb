require 'spec'
require File.dirname(__FILE__) + '/screenshot_helper'
require File.dirname(__FILE__) + '/formatter'

module Spec
  module Ui
    module WebappHelper
      include Spec::Ui::ScreenshotHelper
      raise "$RSPEC_IMG_DIR must be defined" if ENV['RSPEC_IMG_DIR'].nil?
      FileUtils.mkdir_p(ENV['RSPEC_IMG_DIR']) unless File.exist?(ENV['RSPEC_IMG_DIR'])
      @@spec_number = 0

      # Call this method from your teardown block to have source and screenshot written to disk.
      def save_screenshot_and_source(browser)
        @@spec_number += 1
        save_screenshot(ENV['RSPEC_IMG_DIR'], @@spec_number)
        save_source(ENV['RSPEC_IMG_DIR'], @@spec_number, browser.html)
      end

      def save_source(dir, spec_number, html)
        File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
      end
    end
  end
end
