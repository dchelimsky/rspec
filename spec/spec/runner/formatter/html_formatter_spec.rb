require File.dirname(__FILE__) + '/../../../spec_helper.rb'
require 'stringio'

context "HtmlFormatter" do
  setup do
    @io = StringIO.new
    @formatter = Spec::Runner::Formatter::HtmlFormatter.new(@io)
  end

  specify "should close html on dump summary" do
    @formatter.dump_summary(3, 2, 1)
    @io.string.should_eql("</body>\n</html>\n")
  end

  specify "should push context name" do
    @formatter.add_context("fruit", false)
    @io.string.should_eql("  </ul>\n</div>\n<div class=\"context\">\n  <ul>\n  <li class=\"context_name\">fruit</li>\n")
  end

  specify "should push div on start dump" do
    @formatter.start_dump
    @io.string.split.last.should_eql("</div>")
  end

  specify "should push div with spec failed class" do
    exception = StandardError.new("boo")
    failure = Spec::Runner::Reporter::Failure.new("context_name", "spec_name", exception)
    @formatter.spec_started("spec_name")
    @formatter.spec_failed("spec_name", 98, failure)
    @io.string.should_match(/<li class="spec failed"/)
  end

  specify "should push div with spec passed class" do
    @formatter.spec_started("spec")
    @formatter.spec_passed("spec")
    @io.string.should_match(/<li class="spec passed"><div class="passed_spec_name">spec<\/div><\/li>/m)
  end

  specify "should push header on start" do
    @formatter.start(5)
    @io.string.should_eql(Spec::Runner::Formatter::HtmlFormatter::HEADER)
  end
  
  specify "should render plain backtrace" do
    @formatter.format_backtrace([
      "foo/bar:3:in `some_method'",
      "foo/bar:4:in `some_other_method'",
      ""
    ]).should_eql <<-EOS
foo/bar:3:in `some_method'
foo/bar:4:in `some_other_method'
EOS
  end

  class CustomHtmlFormatter < Spec::Runner::Formatter::HtmlFormatter
    def backtrace_line(line)
      line.gsub(/([^:]*):(\d*):in /, "<a href=\"nifty://open?url=file:///PREFIX/\\1&line=\\2\">\\1:\\2</a>:in ")
    end
  end

  specify "should render formatted backtrace" do
    @formatter = CustomHtmlFormatter.new(@io)
    @formatter.format_backtrace([
      "foo/bar:3:in `some_method'",
      "foo/bob:4:in `some_other_method'",
      ""
    ]).should_eql <<-EOS
<a href="nifty://open?url=file:///PREFIX/foo/bar&line=3">foo/bar:3</a>:in `some_method'
<a href="nifty://open?url=file:///PREFIX/foo/bob&line=4">foo/bob:4</a>:in `some_other_method'
EOS
  end
  
  specify "should produce HTML identical to the one we designed manually" do
    root = File.expand_path(File.dirname(__FILE__) + '/../../../..')
    Dir.chdir(root) do
      html = `ruby -Ilib bin/spec failing_examples/mocking_example.rb failing_examples/diffing_spec.rb examples/stubbing_example.rb -c -fh`
      expected_html = File.read(File.dirname(__FILE__) + '/html_formatted.html')
      html.should_eql expected_html
    end
  end
  
end
