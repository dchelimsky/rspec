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
          @output.puts "  <ul>"
          @output.puts "  <li class=\"context_name\">#{name}</li>"
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
          @output.puts "    <li class=\"spec passed\"><div class=\"passed_spec_name\">#{escape(@current_spec)}</div></li>"
        end

        def spec_failed(name, counter, failure)
          @output.puts "    <li class=\"spec failed\">"
          @output.puts "      <div class=\"failed_spec_name\">#{escape(@current_spec)}</div>"
          @output.puts "      <div class=\"failure\" id=\"failure_#{counter}\">"
          @output.puts "        <div class=\"message\"><pre>#{escape(failure.exception.message)}</pre></div>" unless failure.exception.nil?
          @output.puts "        <div class=\"backtrace\"><pre>#{format_backtrace(failure.exception.backtrace)}</pre></div>" unless failure.exception.nil?
          @output.puts "      </div>"
          @output.puts "    </li>"
          STDOUT.flush
        end
        
        def escape(string)
          string.gsub(/&/n, '&amp;').gsub(/\"/n, '&quot;').gsub(/>/n, '&gt;').gsub(/</n, '&lt;')
        end
    
        def dump_failure(counter, failure)
        end

        def dump_summary(duration, spec_count, failure_count)
          @output.puts "</body>"
          @output.puts "</html>"
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
    font-size: 9pt;
    font-family: verdana, arial, helvetica;
    width: 85%;
  }

  div.context {
    padding: 0px;
    background: #fff;
    margin-top: 0px;
  }

  ul {
    padding-left: 0px;
  }

  li { 
    list-style-type: none; 
    margin: 0;
    border: 1px solid #fff;
  }

  li.context_name {
    font-size: 1.3em;
    font-weight: bold;
    color: #589CCF;
  }

  div.passed_spec_name {
    font-weight: bold;
    color: #324F17;
  }

  div.failed_spec_name {
    font-weight: bold;
    color: #EEB4B4;
  }

  li.passed {
    display: block; 
    background: #659D32; 
    padding: 1px 4px; 
  }

  li.failed {
    display: block; 
    background: #CD0000; 
    color: #000; 
    padding: 2px 4px; 
  }

  li.failed .failure {
    font-weight: normal;
    font-size: 9pt;
  }

  div.backtrace {
    color: #000; 
  }

  </style>
</head>
<body>
HEADER
      end
    end
  end
end