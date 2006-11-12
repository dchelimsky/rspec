module Spec
  module Runner
    module Formatter
      class HtmlFormatter < BaseTextFormatter
        def initialize(output, dry_run=false, colour=false)
          super
          @current_count = 0
          @spec_count = 0
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
          STDOUT.flush
        end

        def start_dump
          @output.puts "  </ul>"
          @output.puts "</div>"
          STDOUT.flush
        end

        def spec_started(name)
          @current_spec = name
          @current_count += 1
          STDOUT.flush
        end

        def spec_passed(name)
          move_progress
          @output.puts "    <li class=\"spec passed\"><div class=\"passed_spec_name\">#{escape(@current_spec)}</div></li>"
          STDOUT.flush
        end

        def spec_failed(name, counter, failure)
          @output.puts "    <script type=\"text/javascript\">makeProgressbarRed();</script>"
          move_progress
          @output.puts "    <li class=\"spec failed\">"
          @output.puts "      <div class=\"failed_spec_name\">#{escape(@current_spec)}</div>"
          @output.puts "      <div class=\"failure\" id=\"failure_#{counter}\">"
          @output.puts "        <div class=\"message\"><pre>#{escape(failure.exception.message)}</pre></div>" unless failure.exception.nil?
          @output.puts "        <div class=\"backtrace\"><pre>#{format_backtrace(failure.exception.backtrace)}</pre></div>" unless failure.exception.nil?
          @output.puts "      </div>"
          @output.puts "    </li>"
          STDOUT.flush
        end
        
        def move_progress
          percent_done = @spec_count == 0 ? 100.0 : (@current_count.to_f / @spec_count.to_f * 1000).to_i / 10.0
          @output.puts "    <script type=\"text/javascript\">moveProgressBar('#{percent_done}');</script>"
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
        
        RED_BACKGROUND   = '#CD0000'
        GREEN_BACKGROUND = '#659D32'
        
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
  <script type="text/javascript">
  function moveProgressBar(percentDone) {
    document.getElementById("progress-bar").style.width = percentDone +"%";
  }
  function makeProgressbarRed() {
    document.getElementById('progress-bar').style.background = '#{RED_BACKGROUND}';
  }
  </script>
  <style type="text/css">
  body {
    font-size: 9pt;
    font-family: verdana, arial, helvetica;
    width: 85%;
  }

  #progress-bar-bg {
    background-color: #C9C9C9; 
    border-bottom: 1px solid gray; 
    border-right: 1px solid gray;
  }

  #progress-bar {
    background-color: #{GREEN_BACKGROUND};
    width: 0px;
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
    color: #fff; 
  }

  div.backtrace a {
    color: #fff; 
  }

  </style>
</head>
<body>

<div id="progress-bar-bg">
  <div id="progress-bar">&nbsp;</div>
</div>

HEADER
      end
    end
  end
end