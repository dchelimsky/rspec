require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'stringio'

context "HtmlFormatter" do
  specify "should produce HTML identical to the one we designed manually" do
    root = File.expand_path(File.dirname(__FILE__) + '/../../../..')
    expected_file = File.dirname(__FILE__) + '/html_formatted.html'
    expected_html = File.read(expected_file)
    Dir.chdir(root) do
      err = StringIO.new
      out = StringIO.new
      Spec::Runner::CommandLine.run(
        ['failing_examples/mocking_example.rb', 'failing_examples/diffing_spec.rb', 'examples/stubbing_example.rb', '-f', 'h'],
        err,
        out
      )
      
      seconds = /\d+\.\d+ seconds/
      html = out.string.gsub seconds, 'x seconds'
      expected_html.gsub! seconds, 'x seconds'
      #File.open(expected_file + ".html", 'w') {|io| io.write(html)}
      html.should_eql expected_html
    end
  end
  
end
