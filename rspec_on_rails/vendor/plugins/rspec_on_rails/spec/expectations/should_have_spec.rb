# receiver.should_have
#
# This is the RSpec port of assert_select. If you are using
# Rails <= 1.1.6, you need to install the assert_select plugin
# in order for this to work. Rails >= 1.2.0 RC 1 already
# includes it.

require File.dirname(__FILE__) + '/../spec_helper'

# assert_select plugins for Rails
#
# Copyright (c) 2006 Assaf Arkin, under Creative Commons Attribution and/or MIT License
# Developed for http://co.mments.com
# Code and documention: http://labnotes.org

class ShouldHaveController < ActionController::Base

  def response=(content)
    @content = content
  end

  def response(&block)
    @update = block
  end

  def html()
    render :text=>@content, :layout=>false, :content_type=>Mime::HTML
    @content = nil
  end

  def rjs()
    render :update do |page|
      @update.call page
    end
    @update = nil
  end

  def xml()
    render :text=>@content, :layout=>false, :content_type=>Mime::XML
    @content = nil
  end

  def rescue_action(e)
    raise e
  end

end


class ShouldHaveMailer < ActionMailer::Base

  def test(html)
    recipients "test <test@test.host>"
    from "test@test.host"
    subject "Test e-mail"
    part :content_type=>"text/html", :body=>html
  end

end

# SpecFailed = Spec::Expectations::ExpectationNotMetError

context "ShouldHave", :context_type => :controller do
  controller_name :should_have

  setup do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end


  teardown do
    ActionMailer::Base.deliveries.clear
  end


  #
  # Test assert select.
  #

  specify "should have" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    response.should_have "div", 2
    lambda { response.should_have "div", 3 }.should_raise SpecFailed
    lambda { response.should_have "p" }.should_raise SpecFailed
  end


  specify "equality" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    lambda { response.should_have "div" }.should_not_raise
    lambda { response.should_have "p" }.should_raise SpecFailed
    lambda { response.should_have "div", true }.should_not_raise
    lambda { response.should_have "p", true }.should_raise SpecFailed
    lambda { response.should_have "div", false }.should_raise SpecFailed
    lambda { response.should_have "p", false }.should_not_raise
  end


  specify "equality_string_and_regexp" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    lambda { response.should_have "div", "foo" }.should_not_raise
    lambda { response.should_have "div", "bar" }.should_raise SpecFailed
    lambda { response.should_have "div", :text=>"foo" }.should_not_raise
    lambda { response.should_have "div", :text=>"bar" }.should_raise SpecFailed
    lambda { response.should_have "div", /(foo|bar)/ }.should_not_raise
    lambda { response.should_have "div", /foobar/ }.should_raise SpecFailed
    lambda { response.should_have "div", :text=>/(foo|bar)/ }.should_not_raise
    lambda { response.should_have "div", :text=>/foobar/ }.should_raise SpecFailed
    lambda { response.should_have "p", :text=>/foobar/ }.should_raise SpecFailed
  end


  specify "html should be stripped for equality check" do
    render_html %Q{<p>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</p>}
    text = "\"This is not a big problem,\" he said."
    html = "<em>\"This is <strong>not</strong> a big problem,\"</em> he said."
    lambda { response.should_have "p", text }.should_not_raise
    lambda { response.should_have "p", html }.should_raise SpecFailed
    lambda { response.should_have "p", :html=>html }.should_not_raise
    lambda { response.should_have "p", :html=>text }.should_raise SpecFailed
  end

  specify "html should NOT be stripped from 'pre' tag for equality check (?????? this is confusing - I think this spec is wrong)" do
    render_html %Q{<pre>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</pre>}
    text = "\n\"This is not a big problem,\" he said.\n"
    html = "\n<em>\"This is <strong>not</strong> a big problem,\"</em> he said.\n"
    lambda { response.should_have "pre", text }.should_not_raise
    lambda { response.should_have "pre", html }.should_raise SpecFailed
    lambda { response.should_have "pre", :html=>html }.should_not_raise
    lambda { response.should_have "pre", :html=>text }.should_raise SpecFailed
  end


  specify "equality_of_instances" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    lambda { response.should_have "div", 2 }.should_not_raise
    lambda { response.should_have "div", 3 }.should_raise SpecFailed
    lambda { response.should_have "div", 1..2 }.should_not_raise
    lambda { response.should_have "div", 3..4 }.should_raise SpecFailed
    lambda { response.should_have "div", :count=>2 }.should_not_raise
    lambda { response.should_have "div", :count=>3 }.should_raise SpecFailed
    lambda { response.should_have "div", :minimum=>1 }.should_not_raise
    lambda { response.should_have "div", :minimum=>2 }.should_not_raise
    lambda { response.should_have "div", :minimum=>3 }.should_raise SpecFailed
    lambda { response.should_have "div", :maximum=>2 }.should_not_raise
    lambda { response.should_have "div", :maximum=>3 }.should_not_raise
    lambda { response.should_have "div", :maximum=>1 }.should_raise SpecFailed
    lambda { response.should_have "div", :minimum=>1, :maximum=>2 }.should_not_raise
    lambda { response.should_have "div", :minimum=>3, :maximum=>4 }.should_raise SpecFailed
  end


  specify "substitution_values" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    response.should_have "div#?", /\d+/ do |elements|
      elements.size.should == 2
    end
    response.should_have "div" do
      response.should_have "div#?", /\d+/ do |elements|
        elements.size.should == 2
        response.should_have "#1"
        response.should_have "#2"
      end
    end
  end

  
  specify "nested" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    response.should_have "div" do |elements|
      elements.size.should == 2
      response.should_have elements[0], "#1"
      response.should_have elements[1], "#2"
    end
    response.should_have "div" do
      response.should_have "div" do |elements|
        elements.size.should == 2
        # Testing in a group is one thing
        response.should_have "#1,#2"
        # Testing individually is another.
        response.should_have "#1"
        response.should_have "#2"
        response.should_have "#3", false
      end
    end
  end


  specify "assert_select_text_match" do
    render_html %Q{<div id="1"><span>foo</span></div><div id="2"><span>bar</span></div>}
    response.should_have "div" do
      lambda { response.should_have "div", "foo" }.should_not_raise
      lambda { response.should_have "div", "bar" }.should_not_raise
      lambda { response.should_have "div", /\w*/ }.should_not_raise
      lambda { response.should_have "div", /\w*/, :count=>2 }.should_not_raise
      lambda { response.should_have "div", :text=>"foo", :count=>2 }.should_raise SpecFailed
      lambda { response.should_have "div", :html=>"<span>bar</span>" }.should_not_raise
      lambda { response.should_have "div", :html=>"<span>bar</span>" }.should_not_raise
      lambda { response.should_have "div", :html=>/\w*/ }.should_not_raise
      lambda { response.should_have "div", :html=>/\w*/, :count=>2 }.should_not_raise
      lambda { response.should_have "div", :html=>"<span>foo</span>", :count=>2 }.should_raise SpecFailed
    end
  end


  # TODO - no RJS yet - need to come up w/ a name
  # specify "assert_select_from_rjs" do
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
  #   end
  #   response.should_have "div" do |elements|
  #     elements.size.should == 2
  #     response.should_have "#1"
  #     response.should_have "#2"
  #   end
  #   response.should_have "div#?", /\d+/ do |elements|
  #     response.should_have "#1"
  #     response.should_have "#2"
  #   end
  #   # With multiple results.
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #   end
  #   response.should_have "div" do |elements|
  #     elements.size.should == 2
  #     response.should_have "#1"
  #     response.should_have "#2"
  #   end
  # end

  # def test_css_select_from_rjs
  #   # With one result.
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
  #   end
  #   assert_equal 2, css_select("div").size
  #   assert_equal 1, css_select("#1").size
  #   assert_equal 1, css_select("#2").size
  #   # With multiple results.
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #   end
  #   assert_equal 2, css_select("div").size
  #   assert_equal 1, css_select("#1").size
  #   assert_equal 1, css_select("#2").size
  # end


  #
  # Test assert_select_rjs.
  #

  # def test_assert_select_rjs
  #   # Test that we can pick up all statements in the result.
  #   render_rjs do |page|
  #     page.replace "test", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #     page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
  #   end
  #   found = false
  #   assert_select_rjs do
  #     assert_select "#1"
  #     assert_select "#2"
  #     assert_select "#3"
  #     found = true
  #   end
  #   assert found
  #   # Test that we fail if there is nothing to pick.
  #   render_rjs do |page|
  #   end
  #   lambda { assert_select_rjs }.should_raise SpecFailed
  # end
  # 
  # 
  # def test_assert_select_rjs_with_id
  #   # Test that we can pick up all statements in the result.
  #   render_rjs do |page|
  #     page.replace "test1", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #     page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
  #   end
  #   assert_select_rjs "test1" do
  #     assert_select "div", 1
  #     assert_select "#1"
  #   end
  #   assert_select_rjs "test2" do
  #     assert_select "div", 1
  #     assert_select "#2"
  #   end
  #   assert_select_rjs "test3" do
  #     assert_select "div", 1
  #     assert_select "#3"
  #   end
  #   lambda { assert_select_rjs "test4" }.should_raise SpecFailed
  # end
  # 
  # def test_assert_select_rjs_for_replace
  #   render_rjs do |page|
  #     page.replace "test1", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #     page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
  #   end
  #   # Replace.
  #   assert_select_rjs :replace do
  #     assert_select "div", 1
  #     assert_select "#1"
  #   end
  #   assert_select_rjs :replace, "test1" do
  #     assert_select "div", 1
  #     assert_select "#1"
  #   end
  #   lambda { assert_select_rjs :replace, "test2" }.should_raise SpecFailed
  #   # Replace HTML.
  #   assert_select_rjs :replace_html do
  #     assert_select "div", 1
  #     assert_select "#2"
  #   end
  #   assert_select_rjs :replace_html, "test2" do
  #     assert_select "div", 1
  #     assert_select "#2"
  #   end
  #   lambda { assert_select_rjs :replace_html, "test1" }.should_raise SpecFailed
  # end
  # 
  # def test_assert_select_rjs_for_insert
  #   render_rjs do |page|
  #     page.replace "test1", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #     page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
  #   end
  #   # Non-positioned.
  #   assert_select_rjs :insert_html do
  #     assert_select "div", 1
  #     assert_select "#3"
  #   end
  #   assert_select_rjs :insert_html, "test3" do
  #     assert_select "div", 1
  #     assert_select "#3"
  #   end
  #   lambda { assert_select_rjs :insert_html, "test1" }.should_raise SpecFailed
  #   # Positioned.
  #   render_rjs do |page|
  #     page.insert_html :top, "test1", "<div id=\"1\">foo</div>"
  #     page.insert_html :bottom, "test2", "<div id=\"2\">foo</div>"
  #     page.insert_html :before, "test3", "<div id=\"3\">foo</div>"
  #     page.insert_html :after, "test4", "<div id=\"4\">foo</div>"
  #   end
  #   assert_select_rjs :insert, :top do
  #     assert_select "div", 1
  #     assert_select "#1"
  #   end
  #   assert_select_rjs :insert, :bottom do
  #     assert_select "div", 1
  #     assert_select "#2"
  #   end
  #   assert_select_rjs :insert, :before do
  #     assert_select "div", 1
  #     assert_select "#3"
  #   end
  #   assert_select_rjs :insert, :after do
  #     assert_select "div", 1
  #     assert_select "#4"
  #   end
  #   assert_select_rjs :insert_html do
  #     assert_select "div", 4
  #   end
  # end
  # 
  # def test_nested_assert_select_rjs
  #   # Simple selection from a single result.
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
  #   end
  #   assert_select_rjs "test" do |elements|
  #     assert_equal 2, elements.size
  #     assert_select "#1"
  #     assert_select "#2"
  #   end
  #   # Deal with two results.
  #   render_rjs do |page|
  #     page.replace_html "test", "<div id=\"1\">foo</div>"
  #     page.replace_html "test2", "<div id=\"2\">foo</div>"
  #   end
  #   assert_select_rjs "test" do |elements|
  #     assert_equal 1, elements.size
  #     assert_select "#1"
  #   end
  #   assert_select_rjs "test2" do |elements|
  #     assert_equal 1, elements.size
  #     assert_select "#2"
  #   end
  # end


  #
  # Test assert_select_feed and assert_select_encoded
  #

  specify "feed_versions" do
    # Atom 1.0.
    render_xml %Q{<feed xmlns="http://www.w3.org/2005/Atom"><title>test</title></feed>}
    lambda { response.should_have_feed :atom }.should_not_raise
    lambda { response.should_have_feed :atom, 1.0 }.should_not_raise
    lambda { response.should_have_feed :atom, 0.3 }.should_raise SpecFailed
    lambda { response.should_have_feed :rss }.should_raise SpecFailed
    response.should_have_feed(:atom, 1.0) { response.should_have "feed>title", "test" }
    # Atom 0.3.
    render_xml %Q{<feed version="0.3"><title>test</title></feed>}
    lambda { response.should_have_feed :atom, 0.3 }.should_not_raise
    lambda { response.should_have_feed :atom }.should_raise SpecFailed
    lambda { response.should_have_feed :atom, 1.0 }.should_raise SpecFailed
    lambda { response.should_have_feed :rss }.should_raise SpecFailed
    response.should_have_feed(:atom, 0.3) { response.should_have "feed>title", "test" }
    # RSS 2.0.
    render_xml %Q{<rss version="2.0"><channel><title>test</title></channel></rss>}
    lambda { response.should_have_feed :rss }.should_not_raise
    lambda { response.should_have_feed :rss, 2.0 }.should_not_raise
    lambda { response.should_have_feed :rss, 0.92 }.should_raise SpecFailed
    lambda { response.should_have_feed :atom }.should_raise SpecFailed
    response.should_have_feed(:rss, 2.0) { response.should_have "rss>channel>title", "test" }
    # RSS 0.92.
    render_xml %Q{<rss version="0.92"><channel><title>test</title></channel></rss>}
    lambda { response.should_have_feed :rss, 0.92 }.should_not_raise
    lambda { response.should_have_feed :rss }.should_raise SpecFailed
    lambda { response.should_have_feed :rss, 2.0 }.should_raise SpecFailed
    lambda { response.should_have_feed :atom }.should_raise SpecFailed
    response.should_have_feed(:rss, 0.92) { response.should_have "rss>channel>title", "test" }
  end


  specify "feed_item_encoded" do
    render_xml <<-EOF
<rss version="2.0">
  <channel>
    <item>
      <description>
        <![CDATA[
          <p>Test 1</p>
        ]]>
      </description>
    </item>
    <item>
      <description>
        <![CDATA[
          <p>Test 2</p>
        ]]>
      </description>
    </item>
  </channel>
</rss>
EOF
    response.should_have_feed :rss, 2.0 do
      response.should_have "channel item description" do
        # Test element regardless of wrapper.
        response.should_have_encoded do
          response.should_have "p", :count=>2, :text=>/Test/
        end
        # Test through encoded wrapper.
        response.should_have_encoded do
          response.should_have "encoded p", :count=>2, :text=>/Test/
        end
        # Use :root instead (recommended)
        response.should_have_encoded do
          response.should_have ":root p", :count=>2, :text=>/Test/
        end
        # Test individually.
        response.should_have "description" do |elements|
          response.should_have_encoded elements[0] do
            response.should_have "p", "Test 1"
          end
          response.should_have_encoded elements[1] do
            response.should_have "p", "Test 2"
          end
        end
      end
    end
    # Test that we only un-encode element itself.
    response.should_have_feed :rss, 2.0 do
      response.should_have "channel item" do
        response.should_have_encoded do
          response.should_have "p", 0
        end
      end
    end
  end


  #
  # Test assert_select_email
  #

  specify "should_have_email" do
    lambda { response.should_have_email {} }.should_raise SpecFailed
    ShouldHaveMailer.deliver_test "<div><p>foo</p><p>bar</p></div>"
    response.should_have_email do
      response.should_have "div:root" do
        response.should_have "p:first-child", "foo"
        response.should_have "p:last-child", "bar"
      end
    end
  end


protected

  def render_html(html)
    @controller.response = html
    get :html
  end


  def render_rjs(&block)
    @controller.response &block
    get :rjs
  end


  def render_xml(xml)
    @controller.response = xml
    get :xml
  end

end