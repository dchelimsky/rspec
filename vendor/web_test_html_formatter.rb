# Customizes the HTML report to include screenshots and browser source, which
# are saved in teardown defined in rspec_watir.rb
class WebTestHtmlFormatter < Spec::Runner::Formatter::HtmlFormatter
  def extra_failure_content
    @output.puts "        <div><a href=\"images/#{@current_count}.png\"><img src=\"images/#{@current_count}_thumb.png\"></a></div>"
    @output.puts "        <div><a href=\"images/#{@current_count}.html\">HTML source</a></div>"
  end
end