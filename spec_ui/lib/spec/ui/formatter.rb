module Spec
  module Ui
    class ScreenshotFormatter < Spec::Runner::Formatter::HtmlFormatter
      def extra_failure_content
        "        <div><a href=\"images/#{current_spec_number}.png\"><img width=\"25%\" height=\"25%\" src=\"images/#{current_spec_number}.png\"></a></div>\n"
      end
    end

    class WebappFormatter < ScreenshotFormatter
      def extra_failure_content
        super + "        <div><a href=\"images/#{current_spec_number}.html\">HTML source</a></div>\n"
      end
    end
  end
end