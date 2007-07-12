require 'spec/ui/screenshot_saver'
require 'stringio'

module Spec
  module Ui
    class ScreenshotFormatter < Spec::Runner::Formatter::HtmlFormatter
      class << self
        attr_accessor :instance
      end

      include ScreenshotSaver

      def initialize(where, out=where)
        super(out)
        if where.is_a?(String)
          @root = File.dirname(where)
        else
          raise "#{self.class} must write to a file, so that we know where to store screenshots"
        end
        raise "Only one instance of #{self.class} is allowed" unless self.class.instance.nil?
        ScreenshotFormatter.instance = self
      end
      
      # Takes screenshot and snapshot of the +browser+'s html.
      # This method calls #screenshot! so that method should not be called
      # when this method is used.
      # This method *must* be called in an after(:each) block.
      def take_screenshot_of(browser)
        screenshot
        save_html(browser)
      end
      
      # Takes a screenshot of the current window and saves it to disk. 
      # Use this method when you don't have a browser object.
      def screenshot
        png_path = File.join(@root, relative_png_path)
        ensure_dir(png_path)
        save_screenshot(png_path)
      end
      
      # Writes the HTML from +browser+ to disk
      def save_html(browser)
        ensure_dir(absolute_html_path)
        File.open(absolute_html_path, "w") {|io| io.write(browser.html)}
      end
      
      def ensure_dir(file)
        dir = File.dirname(file)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
      end

      def absolute_png_path
        File.join(@root, relative_png_path)
      end

      def relative_png_path
        "images/#{current_example_number}.png"
      end

      def absolute_html_path
        File.join(@root, relative_html_path)
      end

      def relative_html_path
        "html/#{current_example_number}.html"
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
    link.innerHTML = "show snapshot"
  }
  else
  {
    elem.style.display = "block"
    link.innerHTML = "hide snapshot"
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
        if File.exist?(absolute_png_path)
          result += img_div 
        end
        if File.exist?(absolute_html_path)
          source_id = "#{current_example_number}_source"
          result += "        <div>[<a id=\"l_#{source_id}\" href=\"javascript:toggleSource('#{source_id}')\">show snapshot</a>]</div>\n"
          result += "        <div id=\"#{source_id}\" class=\"dyn-source\"><iframe src=\"#{relative_html_path}\" width=\"100%\" height=\"300px\"></iframe></div>\n"
        end
        result
      end
 
      def img_div
        "        <div><a href=\"#{relative_png_path}\"><img width=\"25%\" height=\"25%\" src=\"#{relative_png_path}\" /></a></div>\n"
      end
    end
    
    # This formatter produces the same HTML as ScreenshotFormatter, except that
    # it doesn't save screenshot PNGs and browser snapshot HTML source to disk. 
    # It is meant to be used from a Spec::Distributed master
    class MasterScreenshotFormatter < ScreenshotFormatter
      def screenshot
      end
      
      def save_html(browser)
      end
    end
    
    # This formatter writes PNG and browser snapshot HTML to disk, just like its superclass,
    # but it doesn't write the HTML report itself.
    # It is meant to be used from Spec::Distributed slaves
    class SlaveScreenshotFormatter < ScreenshotFormatter
      def initialize(where)
        super(where, StringIO.new)
      end
    end
  end
end
