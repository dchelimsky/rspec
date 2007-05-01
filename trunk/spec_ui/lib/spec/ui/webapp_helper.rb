require 'spec'
require File.dirname(__FILE__) + '/screenshot_helper'
require File.dirname(__FILE__) + '/formatter'

module Spec
  module Ui
    module WebappHelper
      include Spec::Ui::ScreenshotHelper
      @@spec_number = 0

      # Call this method from your teardown block to have source and screenshot written to disk.
      def save_screenshot_and_source(browser)
        save_screenshot(Spec::Runner.configuration.spec_ui_image_dir, @@spec_number)
        save_source(Spec::Runner.configuration.spec_ui_image_dir, @@spec_number, browser.html)
        @@spec_number += 1
      end

      def save_source(dir, spec_number, html)
        File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
      end
    end
  end
end
