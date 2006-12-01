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
            @output.puts "  </dl>"
            @output.puts "</div>"
          end
          @output.puts "<div class=\"context\">"
          @output.puts "  <dl>"
          @output.puts "  <dt>#{name}</dt>"
          STDOUT.flush
        end

        def start_dump
          @output.puts "  </dl>"
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
          @output.puts "    <dd class=\"spec passed\"><span class=\"passed_spec_name\">#{escape(@current_spec)}</span></dd>"
          STDOUT.flush
        end

        def spec_failed(name, counter, failure)
          @output.puts "    <script type=\"text/javascript\">makeProgressbarRed();</script>"
          move_progress
          @output.puts "    <dd class=\"spec failed\">"
          @output.puts "      <span class=\"failed_spec_name\">#{escape(@current_spec)}</span>"
          @output.puts "      <div class=\"failure\" id=\"failure_#{counter}\">"
          @output.puts "        <div class=\"message\"><pre>#{escape(failure.exception.message)}</pre></div>" unless failure.exception.nil?
          @output.puts "        <div class=\"backtrace\"><pre>#{format_backtrace(failure.exception.backtrace)}</pre></div>" unless failure.exception.nil?
          extra_failure_content
          @output.puts "      </div>"
          @output.puts "    </dd>"
          STDOUT.flush
        end
        
        # Override this method if you wish to output extra HTML for a failed spec. For example, you
        # could output links to images or other files produced during the specs. Example:
        #
        #
        def extra_failure_content
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
          @output.puts "<div id=\"summary\" class=\"#{failure_count == 0 ? 'success' : 'failures'}\""
          if @dry_run
            @output.puts "This was a dry-run"
          else
            @output.puts "<p>Finished in <strong>#{duration} seconds</strong></p>"
            summary = "#{spec_count} specification#{'s' unless spec_count == 1}, #{failure_count} failure#{'s' unless failure_count == 1}"
            @output.puts "<p id=\"totals\">#{summary}</p>"
          end
          @output.puts "</div>"
          @output.puts "</div>"
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
  <script type="text/javascript">
  function moveProgressBar(percentDone) {
    document.getElementById("progress-bar").style.width = percentDone +"%";
  }
  function makeProgressbarRed() {
    document.getElementById('progress-bar').style.background = '#C40D0D';
  }
  </script>
  <style type="text/css">
  body {
    margin: 0; padding: 0;
    background: #fff;
  }

  h1 {
    margin: 0 0 10px;
    padding: 10px;
    font: bold 18px "Lucida Grande", Helvetica, sans-serif;
    background: #0B3563; color: #fff;
  }

  #progress-bar-bg {
    background-color: #C9C9C9; 
    border-bottom: 1px solid gray; 
    border-right: 1px solid gray;

  }

  #progress-bar {
    background-color: #DBFFB4;
    width: 0px;
  }

  .context {
    margin: 0 10px 5px;
    background: #fff;
  }

  dl {
    margin: 0; padding: 0 0 5px;
    font: normal 11px "Lucida Grande", Helvetica, sans-serif;
  }

  dt {
    padding: 3px;
    background: #0B3563;
    color: #fff;
    font-weight: bold;
  }

  dd {
    margin: 5px 0 5px 5px;
    padding: 3px 3px 3px 18px;
  }

  dd.spec.passed {
    border-left: 5px solid #65C400;
    border-bottom: 1px solid #65C400;
    background: #DBFFB4; color: #3D7700;
  }

  dd.spec.failed {
    border-left: 5px solid #C20000;
    border-bottom: 1px solid #C20000;
    color: #C20000; background: #FFFBD3;
  }

  div.backtrace {
    color: #000;
    font-size: 12px;
  }

  a {
    color: #BE5C00;
  }

  #summary {
    margin: 0; padding: 10px 10px;
    font: bold 10px "Lucida Grande", Helvetica, sans-serif;
    background: #0B3563; color: #fff;
    text-align: right;
  }

  #summary.failures {
    background: #C40D0D;
  }

  #summary.success {
    background: #65C400;
  }

  #summary p {
    margin: 0 0 2px;
  }

  #summary #totals {
    font-size: 14px;
  }

  </style>
</head>
<body>

  <h1>RSpec Results</h1>


<div id="progress-bar-bg">
  <div id="progress-bar">&nbsp;</div>
</div>

  <div id="results">
HEADER
      end
    end
  end
end
