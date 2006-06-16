require File.dirname(__FILE__) + '/../../../test_helper'
module Spec
  module Runner
    module Formatter
      class HtmlFormatterTest < Test::Unit::TestCase

        def setup
          @io = StringIO.new
          @formatter = HtmlFormatter.new(@io)
        end

        def test_should_push_header_on_start
          @formatter.start(5)
          assert_equal(HtmlFormatter::HEADER, @io.string)
        end

        def test_should_push_context_name
          @formatter.add_context("fruit", true)
          assert_equal("<div class=\"context\">\n  <div>fruit</div>\n  <ul>\n", @io.string)
        end

        def test_should_push_div_with_spec_passed_class
          @formatter.spec_started("spec")
          @formatter.spec_passed("spec")
          assert_equal("<li class=\"spec passed\">spec</li>\n", @io.string)
        end

        def test_should_push_div_with_spec_failed_class
          exception = StandardError.new("boo")
          failure = Reporter::Failure.new("context_name", "spec_name", exception)
          @formatter.spec_started("spec_name")
          @formatter.spec_failed("spec_name", 98, failure)
          assert_match(/<li class="spec failed"/, @io.string)
        end

        def test_should_close_html_on_dump_summary
          @formatter.dump_summary(3,2,1)
          assert_equal("</body></html>", @io.string)
        end

        def test_should_push_div_on_start_dump
          @formatter.start_dump
          assert_equal("</div>", @io.string.split.last)
        end
      end
    end
  end
end