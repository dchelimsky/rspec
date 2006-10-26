module Spec
  module Runner
    module Formatter
      class HtmlFormatter < BaseTextFormatter
        def initialize(output, dry_run=false, colour=false)
          super
          @current_count = 0
        end
      
        def start(spec_count)
          @spec_count = spec_count
      
          @output.puts HEADER
          STDOUT.flush
        end

        def add_context(name, first)
          unless first
            @output.puts "  </ul>"
            @output.puts "</div>"
          end
          @output.puts "<div class=\"context\">"
          @output.puts "  <div>#{name}</div>"
          @output.puts "  <ul>"
        end

        def start_dump
          @output.puts "  </ul>"
          @output.puts "</div>"
          STDOUT.flush
        end

        def spec_started(name)
          @current_spec = name
          @current_count += 1
        end

        def spec_passed(name)
          @output.puts "<li class=\"spec passed\">#{escape(@current_spec)}</li>"
        end

        def spec_failed(name, counter, failure)
          @output.puts "<li class=\"spec failed\" onclick=\"toggle('failure_#{counter}');return false;\">"
          @output.puts "  <div>#{escape(@current_spec)}</div>"
          @output.puts "  <div class=\"failure\" id=\"failure_#{counter}\" style=\"display:none\">"
          @output.puts "    <div><pre>#{escape(failure.header)}</pre></div>" unless failure.header == ""
          @output.puts "    <div><pre>#{escape(failure.message)}</pre></div>" unless failure.message == ""
          @output.puts "    <div><pre>#{escape(failure.backtrace)}</pre></div>" unless failure.backtrace == ""
          @output.puts "  </div>"
          @output.puts "</li>"
          STDOUT.flush
        end
    
        def escape(string)
          string.gsub(/&/n, '&amp;').gsub(/\"/n, '&quot;').gsub(/>/n, '&gt;').gsub(/</n, '&lt;')
        end
    
        def dump_failure(counter, failure)
    #      @output.print "\n"
    #      @output.print counter.to_s << ")\n"
    #      @output.print "#{failure.header}\n"
    #      @output.print "#{failure.message}\n"
    #      @output.print "#{failure.backtrace}\n"
    #      STDOUT.flush
        end

        def dump_summary(duration, spec_count, failure_count)
          @output.print "</body>"
          @output.print "</html>"
          STDOUT.flush
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

    ul {
      padding-left: 8px;
    }

    li.passed {
      background-color: #DDFFDD;
    }

    li { 
      list-style-type: none; 
      margin: 0;
    }

    li.failed {
      background-color: #FFBBBB;
      font-weight: bold;
    }

    li.failed:hover {
      color: #FFFFFF;
      background-color: #FF0000;
    }

    li.failed .failure {
      font-weight: normal;
      font-size: 9pt;
    }

    div.context {
      padding:4px;
      border:1px solid #000000;
      margin-top:4px;
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
end