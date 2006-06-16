require 'spec/runner/base_text_formatter'

module Spec
  module Runner
    class HtmlFormatter < Spec::Runner::BaseTextFormatter
      def initialize(output, dry_run=false)
        super
        @current_count = 0
      end
      
      def start(spec_count)
        @spec_count = spec_count
      
        @output.puts HEADER
        @output.flush
      end

      def add_context(name, first)
        unless first
          @output.puts "  </div>"
          @output.puts "</div>"
        end
        @output.puts "<div class=\"context\">"
        @output.puts "  <div>#{name}</div>"
        @output.puts "  <div>"
      end

      def start_dump
        @output.puts "  </div>"
        @output.puts "</div>"
        @output.flush
      end

      def spec_started(name)
        @current_spec = name
        @current_count += 1
      end

      def spec_passed(name)
        @output.puts "<div class=\"spec passed\">#{escape(@current_spec)}</div>"
      end

      def spec_failed(name, counter, failure)
        @output.puts "<div class=\"spec failed\">"
        @output.puts "  <a href=\"#\" onclick=\"toggle('failure_#{counter}');return false;\">#{escape(@current_spec)}</a>"
        @output.puts "  <div class=\"failure\" id=\"failure_#{counter}\" style=\"display:none\">"
        @output.puts "    <div><pre>#{escape(failure.header)}</pre></div>" unless failure.header == ""
        @output.puts "    <div><pre>#{escape(failure.message)}</pre></div>" unless failure.message == ""
        @output.puts "    <div><pre>#{escape(failure.backtrace)}</pre></div>" unless failure.backtrace == ""
        @output.puts "  </div>"
        @output.puts "</div>"
        @output.flush
      end
    
      def escape(string)
        string.gsub(/&/n, '&amp;').gsub(/\"/n, '&quot;').gsub(/>/n, '&gt;').gsub(/</n, '&lt;')
      end
    
      def dump_failure(counter, failure)
  #      @output << "\n"
  #      @output << counter.to_s << ")\n"
  #      @output << "#{failure.header}\n"
  #      @output << "#{failure.message}\n"
  #      @output << "#{failure.backtrace}\n"
  #      @output.flush
      end

      def dump_summary(duration, spec_count, failure_count)
        @output << "</body>"
        @output << "</html>"
        @output.flush
      end
      
      HEADER = <<-HEADER
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>RSpec results</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <style type="text/css">
  body {
    font-size: 10pt;
    font: "lucida grande";
    width: 85%;
  }

  .passed {
    background-color: #DDFFDD;
  }

  .failed {
    background-color: #FFDDDD;
    font-weight: bold;
  }

  .failed .failure {
    background-color: #FFDDDD;
    font-weight: normal;
    font-size: 9pt;
  }

  .context {
    padding:4px;
    border:1px solid #000000;
    margin-top:4px;
  }

  :link, :visited {
    color: #000000;
    text-decoration: none;
    padding-bottom: 0px;
  }

  :link:hover, :visited:hover {
    color: #c00;
  }

  </style>
  <script type="text/javascript">
  // <![CDATA[

  function toggle( id ) {
    if ( document.getElementById )
      elem = document.getElementById( id );
    else if ( document.all )
      elem = eval( "document.all." + id );
    else
      return false;

    elemStyle = elem.style;

    if ( elemStyle.display != "block" ) {
      elemStyle.display = "block"
    } else {
      elemStyle.display = "none"
    }

    return true;
  }
  // ]]>
  </script>

</head>
<body>
HEADER
    end
  end
end