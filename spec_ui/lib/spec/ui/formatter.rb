require 'tempfile'
require 'base64'
require 'cgi'
require 'spec/ui/screenshot_saver'

module Spec
  module Ui
    class ScreenshotFormatter < Spec::Runner::Formatter::HtmlFormatter
      class << self
        include ScreenshotSaver
        attr_reader :html

        # Takes screenshot and snapshot of the +browser+'s html.
        # This method calls #screenshot! so that method should not be called
        # when this method is used.
        # This method *must* be called in an after(:each) block.
        def take_screenshot_of(browser)
          screenshot
          @html = browser.html
        end

        # Takes a screenshot of the current window. Use this method when
        # you don't have a browser object.
        def screenshot
          @png_path = Tempfile.new("spec:ui").path
          save_screenshot(png_path)
        end
        
        def png_path
          raise "Screenshot not taken. You must call #{self.name}.screenshot or #{self.name}.take_screenshot_of(@browser) from after(:each)" if @png_path.nil?
          @png_path
        end
        
        # Resets the screenshot and html. Do not call this method from your specs.
        def reset!
          @png_path = nil
          @html = nil
        end
      end

      def global_scripts
        super + <<-EOF
function showImage(e) {
  w = window.open();
  w.location = e.childNodes[0].src
}

// Lifted from Ruby RDoc
function toggleSource( id ) {
  var elem
  var link

  if( document.getElementById )
  {
    elem = document.getElementById( id )
    link = document.getElementById( "l_" + id )
  }
  else if ( document.all )
  {
    elem = eval( "document.all." + id )
    link = eval( "document.all.l_" + id )
  }
  else
    return false;

  if( elem.style.display == "block" )
  {
    elem.style.display = "none"
    link.innerHTML = "show source"
  }
  else
  {
    elem.style.display = "block"
    link.innerHTML = "hide source"
  }
}
EOF
      end

      def global_styles
        super + <<-EOF
div.rspec-report textarea {
  width: 100%;
}

div.rspec-report div.dyn-source {
  background:#FFFFEE none repeat scroll 0%;
  border:1px dotted black;
  color:#000000;
  display:none;
  margin:0.5em 2em;
  padding:0.5em;
}
EOF
      end

      def extra_failure_content(failure)
        result = super(failure)
        # Add embedded image to the report.
        img_data = Base64.encode64(File.open(self.class.png_path, "rb").read)
        result += "        <div><a href=\"#\" onclick=\"showImage(this)\"><img width=\"25%\" height=\"25%\" src=\"data:image/png;base64,#{img_data}\" /></a></div>\n"
        if self.class.html
          escaped_html = CGI::escapeHTML(self.class.html)
          source_id = "#{current_example_number}_source"
          result += "        <div>[<a id=\"l_#{source_id}\" href=\"javascript:toggleSource('#{source_id}')\">show source</a>]</div>\n"
          result += "        <div id=\"#{source_id}\" class=\"dyn-source\"><textarea rows=\"20\">#{escaped_html}</textarea></div>\n"
        end
        self.class.reset!
        result
      end
    end
  end
end