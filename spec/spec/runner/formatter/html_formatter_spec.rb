require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'stringio'

context "HtmlFormatter" do
  specify "should produce HTML identical to the one we designed manually" do
    root = File.expand_path(File.dirname(__FILE__) + '/../../../..')
    expected_file = File.dirname(__FILE__) + '/html_formatted.html'
    expected_html = File.read(expected_file)
    Dir.chdir(root) do
      args = ['failing_examples/mocking_example.rb', 'failing_examples/diffing_spec.rb', 'examples/stubbing_example.rb', '--format', 'html', '--diff']
      err = StringIO.new
      out = StringIO.new
      Spec::Runner::CommandLine.run(
        args,
        err,
        out
      )

      seconds = /\d+\.\d+ seconds/
      html = out.string.gsub seconds, 'x seconds'
      expected_html.gsub! seconds, 'x seconds'
      # Uncomment this line temporarily in order to overwrite the expected with actual.
      # Use with care!!!
      File.open(expected_file, 'w') {|io| io.write(html)}
      expected_html.should == html
    end
  end
  
end
