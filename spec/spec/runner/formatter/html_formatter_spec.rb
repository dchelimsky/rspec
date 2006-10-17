require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Runner
module Formatter
context "HtmlFormatter" do
    setup do
        @io = StringIO.new
        @formatter = HtmlFormatter.new(@io)
      
    end
    specify "should close html on dump summary" do
        @formatter.dump_summary(3, 2, 1)
        @io.string.should_equal("</body></html>")
      
    end

    specify "should push context name" do
        @formatter.add_context("fruit", false)
        @io.string.should_equal("  </ul>\n</div>\n<div class=\"context\">\n  <div>fruit</div>\n  <ul>\n")
    end

    specify "should push div on start dump" do
        @formatter.start_dump
        @io.string.split.last.should_equal("</div>")
      
    end
    specify "should push div with spec failed class" do
        exception=
        exception=StandardError.new("boo")
        failure=Reporter::Failure.new("context_name", "spec_name", exception)
        @formatter.spec_started("spec_name")
        @formatter.spec_failed("spec_name", 98, failure)
        @io.string.should_match(/<li class="spec failed"/)
      
    end
    specify "should push div with spec passed class" do
        @formatter.spec_started("spec")
        @formatter.spec_passed("spec")
        @io.string.should_equal("<li class=\"spec passed\">spec</li>\n")
      
    end
    specify "should push header on start" do
        @formatter.start(5)
        @io.string.should_equal(HtmlFormatter::HEADER)
      
    end
  
end
end
end
end