require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'stringio'

context "HtmlFormatter" do
  specify "should produce HTML identical to the one we designed manually" do
    root = File.expand_path(File.dirname(__FILE__) + '/../../../..')
    expected_html = File.read(File.dirname(__FILE__) + '/html_formatted.html')
    Dir.chdir(root) do
      err = StringIO.new
      out = StringIO.new
      Spec::Runner::CommandLine.run(
        ['failing_examples/mocking_example.rb', 'failing_examples/diffing_spec.rb', 'examples/stubbing_example.rb', '-f', 'h'],
        err,
        out
      )
      
      html = out.string
      # File.open(File.dirname(__FILE__) + "/html_formatted.html", 'w') {|io| io.write(html)}
      html.should_eql expected_html
    end
  end
  
end
