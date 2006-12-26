require 'spec'
require 'spec/ui/screenshot_helper'
require 'spec/ui/webapp_helper'
require 'spec/ui/formatter'

module Spec
  module Ui
    class WebappHelper
      include Spec::Ui::ScreenshotHelper
      raise "$RSPEC_IMG_DIR must be defined" if ENV['RSPEC_IMG_DIR'].nil?
      @@spec_number = 0

      def teardown
        @@spec_number += 1
        save_screenshots(ENV['RSPEC_IMG_DIR'], @@spec_number)
        save_source(ENV['RSPEC_IMG_DIR'], @@spec_number, @browser.html)
      end

      def save_source(dir, spec_number, html)
        File.open("#{dir}/#{spec_number}.html", "w") {|io| io.write(html)}
      end
      
      def context_teardown
        @browser.kill! rescue nil
      end
    end
  end
end

module Spec
  module Runner
    class Context
      def before_context_eval #:nodoc:
        inherit Spec::Ui::WebappHelper
      end
    end
  end
end
