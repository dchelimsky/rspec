require File.dirname(__FILE__) + '/../spec_helper'

# assert_select plugins for Rails
#
# Copyright (c) 2006 Assaf Arkin, under Creative Commons Attribution and/or MIT License
# Developed for http://co.mments.com
# Code and documention: http://labnotes.org

class AssertSelectController < ActionController::Base

  def response=(content)
    @content = content
  end

  #NOTE - this is commented because response is implemented in lib/spec/rails/context/controller
  # def response(&block)
  #   @update = block
  # end
  # 
  def html()
    render :text=>@content, :layout=>false, :content_type=>Mime::HTML
    @content = nil
  end

  def rjs()
    update = @update
    render :update do |page|
      update.call page
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

class AssertSelectMailer < ActionMailer::Base

  def test(html)
    recipients "test <test@test.host>"
    from "test@test.host"
    subject "Test e-mail"
    part :content_type=>"text/html", :body=>html
  end

end

module AssertSelectSpecHelpers
  def render_html(html)
    @controller.response = html
    get :html
  end

  def render_rjs(&block)
    clear_response
    @controller.response &block
    get :rjs
  end

  def render_xml(xml)
    @controller.response = xml
    get :xml
  end
  
  private
    # necessary for 1.2.1
    def clear_response
      render_html("")
    end
end

SpecFailed = Spec::Expectations::ExpectationNotMetError

context "should have_tag", :context_type => :controller do
  include AssertSelectSpecHelpers
  controller_name :assert_select
  integrate_views

  setup do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  teardown do
    ActionMailer::Base.deliveries.clear
  end

  specify "should find specific numbers of elements" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    response.should have_tag( "div" )
    response.should have_tag("div", 2)
    lambda { response.should have_tag("div", 3) }.should_raise SpecFailed, "Expected at least 3 <div> tags, found 2"
    lambda { response.should have_tag("p") }.should_raise SpecFailed, "Expected at least 1 <p> tag, found 0"
  end

  specify "should expect to find elements when using true" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    response.should have_tag( "div", true )
    lambda { response.should have_tag( "p", true )}.should_raise SpecFailed, "Expected at least 1 <p> tag, found 0"
  end

  specify "should expect to not find elements when using false" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    lambda { response.should have_tag( "div", false )}.should_raise SpecFailed, "Expected at most 0 <div> tags, found 2"
    response.should have_tag( "p", false )
  end


  specify "should match submitted text using text or regexp" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    response.should have_tag("div", "foo")
    response.should have_tag("div", /(foo|bar)/)
    response.should have_tag("div", :text=>"foo")
    response.should have_tag("div", :text=>/(foo|bar)/)

    lambda { response.should have_tag("div", "bar") }.should_raise SpecFailed, "Expected <div> with \"bar\""
    lambda { response.should have_tag("div", :text=>"bar") }.should_raise SpecFailed, "Expected <div> with \"bar\""
    lambda { response.should have_tag("p", :text=>"foo") }.should_raise SpecFailed, "Expected at least 1 <p> tag, found 0"

    lambda { response.should have_tag("div", /foobar/) }.should_raise SpecFailed, "Expected <div> with text matching /foobar/"
    lambda { response.should have_tag("div", :text=>/foobar/) }.should_raise SpecFailed, "Expected <div> with text matching /foobar/"
    lambda { response.should have_tag("p", :text=>/foo/) }.should_raise SpecFailed, "Expected at least 1 <p> tag, found 0"
  end



  specify "should match submitted html" do
    render_html %Q{<p>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</p>}
    text = "\"This is not a big problem,\" he said."
    html = "<em>\"This is <strong>not</strong> a big problem,\"</em> he said."
    response.should have_tag("p", text)
    lambda { response.should have_tag("p", html) }.should_raise SpecFailed, "Expected <p> with #{html.inspect}"
    response.should have_tag("p", :html=>html)
    lambda { response.should have_tag("p", :html=>text) }.should_raise SpecFailed, "Expected <p> with #{text.inspect}"

    # # No stripping for pre.
    render_html %Q{<pre>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</pre>}
    text = "\n\"This is not a big problem,\" he said.\n"
    html = "\n<em>\"This is <strong>not</strong> a big problem,\"</em> he said.\n"
    response.should have_tag("pre", text)
    lambda { response.should have_tag("pre", html) }.should_raise SpecFailed, "Expected <pre> with #{html.inspect}"
    response.should have_tag("pre", :html=>html)
    lambda { response.should have_tag("pre", :html=>text) }.should_raise SpecFailed, "Expected <pre> with #{text.inspect}"
  end

  specify "should match number of instances" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    response.should have_tag("div", 2)
    lambda { response.should have_tag("div", 3) }.should_raise SpecFailed
    response.should have_tag("div", 1..2)
    lambda { response.should have_tag("div", 3..4) }.should_raise SpecFailed
    response.should have_tag("div", :count=>2)
    lambda { response.should have_tag("div", :count=>3) }.should_raise SpecFailed
    response.should have_tag("div", :minimum=>1)
    response.should have_tag("div", :minimum=>2)
    lambda { response.should have_tag("div", :minimum=>3) }.should_raise SpecFailed
    response.should have_tag("div", :maximum=>2)
    response.should have_tag("div", :maximum=>3)
    lambda { response.should have_tag("div", :maximum=>1) }.should_raise SpecFailed
    response.should have_tag("div", :minimum=>1, :maximum=>2)
    lambda { response.should have_tag("div", :minimum=>3, :maximum=>4) }.should_raise SpecFailed
  end

  specify "substitution values" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div><span id="3"></span>}
    response.should have_tag("div#?", /\d+/) { |elements|
      elements.size.should == 2
    }
    lambda {
      response.should have_tag("div#?", /\d+/) { |elements|
        elements.size.should == 3
      }
    }.should_raise SpecFailed, "2 should == 3"
    #TODO - this should be a better message like "expected 3, got 2 (using ==)"

    response.should have_tag("div") {
      response.should have_tag("div#?", /\d+/) { |elements|
        elements.size.should == 2
        elements.should have_tag("#1")
        elements.should have_tag("#2")
        elements.should have_tag("#3", false)
      }
    }
  end
  
  #added for RSpec - all others are converted
  specify "nested tags in form" do
    render_html %Q{
      <form action="test">
        <input type="text" name="email">
      </form>
      <form action="other">
        <input type="text" name="other_input">
      </form>
    }
    response.should have_tag("form[action=test]") { |form|
      form.should have_tag("input[type=text][name=email]")
    }
    response.should have_tag("form[action=test]") { |form|
      with_tag("input[type=text][name=email]")
    }
    lambda {
      response.should have_tag("form[action=test]") { |form|
        form.should have_tag("input[type=text][name=other_input]")
      }
    }.should_fail
    lambda {
      response.should have_tag("form[action=test]") {
        with_tag("input[type=text][name=other_input]")
      }
    }.should_fail
  end
  
  specify "beatles" do
    BEATLES = [
      ["John", "Guitar"],
      ["George", "Guitar"],
      ["Paul", "Bass"],
      ["Ringo", "Drums"]
    ]

    render_html %Q{
      <div id="beatles">
        <div class="beatle">
          <h2>John</h2><p>Guitar</p>
        </div>
        <div class="beatle">
          <h2>George</h2><p>Guitar</p>
        </div>
        <div class="beatle">
          <h2>Paul</h2><p>Bass</p>
        </div>
        <div class="beatle">
          <h2>Ringo</h2><p>Drums</p>
        </div>
      </div>          
    }
    response.should have_tag("div#beatles>div[class=\"beatle\"]", true, :count => 4)

    response.should have_tag("div#beatles>div.beatle") {
      BEATLES.each { |name, instrument|
        with_tag("div.beatle>h2", name)
        with_tag("div.beatle>p", instrument)
        without_tag("div.beatle>span")
      }
    }
  end

  specify "assert_select_text_match" do
    render_html %Q{<div id="1"><span>foo</span></div><div id="2"><span>bar</span></div>}
    response.should have_tag("div") { |divs|
      divs.should have_tag("div", "foo")
      divs.should have_tag("div", "bar")
      divs.should have_tag("div", /\w*/)
      divs.should have_tag("div", /\w*/, :count=>2)
      divs.should_not have_tag("div", :text=>"foo", :count=>2)
      divs.should have_tag("div", :html=>"<span>bar</span>")
      divs.should have_tag("div", :html=>"<span>bar</span>")
      divs.should have_tag("div", :html=>/\w*/)
      divs.should have_tag("div", :html=>/\w*/, :count=>2)
      divs.should_not have_tag("div", :html=>"<span>foo</span>", :count=>2)
    }
  end


  specify "assert_select_from_rjs with one item" do
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
    end
    response.should have_tag("div") { |elements|
      elements.size.should == 2
      response.should have_tag("#1")
      response.should have_tag("#2")
    }
    response.should have_tag("div#?", /\d+/) { |elements|
      elements.should have_tag("#1")
      elements.should have_tag("#2")
    }
  end
  
  specify "assert_select_from_rjs with multiple items" do
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
    end
    response.should have_tag("div") { |elements|
      elements.size.should == 2
      elements.should have_tag("#1")
      elements.should have_tag("#2")
    }

    lambda {
      response.should have_tag("div") { |elements|
        elements.should have_tag("#3")
      }
    }.should_fail
  end
end

context "css_select", :context_type => :controller do
  include AssertSelectSpecHelpers
  controller_name :assert_select
  integrate_views

  specify "can select tags from html" do
    render_html %Q{<div id="1"></div><div id="2"></div>}
    css_select("div").size.should == 2
    css_select("p").size.should == 0
  end


  specify "can select nested tags from html" do
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    response.should_have("div#?", /\d+/) { |elements|
      css_select(elements[0], "div").size.should == 1
      css_select(elements[1], "div").size.should == 1
    }
    response.should_have("div") {
      css_select("div").size.should == 2
      css_select("div").each { |element|
        # Testing as a group is one thing
        css_select("#1,#2").should_not be(:empty)
        # Testing individually is another
        css_select("#1").should_not be(:empty)
        css_select("#2").should_not be(:empty)
      }
    }
  end

  specify "can select nested tags from rjs (one result)" do
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
    end
    css_select("div").size.should == 2
    css_select("#1").size.should == 1
    css_select("#2").size.should == 1
  end

  specify "can select nested tags from rjs (two results)" do
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
    end
    css_select("div").size.should == 2
    css_select("#1").size.should == 1
    css_select("#2").size.should == 1
  end
  
end

context "have_rjs behaviour", :context_type => :controller do
  include AssertSelectSpecHelpers
  controller_name :assert_select
  integrate_views

  setup do
    render_rjs do |page|
      page.replace "test1", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">bar</div><div id=\"3\">none</div>"
      page.insert_html :top, "test3", "<div id=\"4\">loopy</div>"
    end
  end
  
  specify "should pass if any rjs exists" do
    response.should have_rjs
  end

  specify "should find all rjs from multiple statements" do
    found = false
    response.should have_rjs {
      response.should have_tag("#1")
      response.should have_tag("#2")
      response.should have_tag("#3")
      found = true
    }
    found.should be(true)
    # Test that we fail if there is nothing to pick.
    render_rjs do |page|
    end
    lambda {
      response.should have_rjs
    }.should_fail
  end

  specify "should find by id" do
    response.should have_rjs("test1") { |rjs|
      rjs.size.should == 1
      rjs.should have_tag("div", 1)
      rjs.should have_tag("div#1", "foo")
    }
    response.should have_rjs("test2") { |rjs|
      rjs.size.should == 2
      rjs.should have_tag("div", 2)
      rjs.should have_tag("div#2", "bar")
      rjs.should have_tag("div#3", "none")
    }
    lambda {
      response.should have_rjs("test4")
    }.should_fail
  end

  specify "should find rjs using :replace" do
    response.should have_rjs(:replace) { |rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("div#1", "foo")
    }
    response.should have_rjs(:replace, "test1") { |rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("div#1", "foo")
    }
    lambda {
      response.should have_rjs(:replace, "test2")
    }.should_fail

    lambda {
      response.should have_rjs(:replace, "test3")
    }.should_fail
  end

  specify "should find rjs using :replace_html" do
    response.should have_rjs(:replace_html) { |rjs|
      rjs.should have_tag("div", 2)
      rjs.should have_tag("div#2", "bar")
      rjs.should have_tag("div#3", "none")
    }

    response.should have_rjs(:replace_html, "test2") { |rjs|
      rjs.should have_tag("div", 2)
      rjs.should have_tag("div#2", "bar")
      rjs.should have_tag("div#3", "none")
    }

    lambda {
      response.should have_rjs(:replace_html, "test1")
    }.should_fail

    lambda {
      response.should have_rjs(:replace_html, "test3")
    }.should_fail
  end
    
  specify "should find rjs using :insert_html (non-positioned)" do
    response.should have_rjs(:insert_html) { |rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("div#4", "loopy")
    }

    response.should have_rjs(:insert_html, "test3") { |rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("div#4", "loopy")
    }

    lambda {
      response.should have_rjs(:insert_html, "test1")
    }.should_fail

    lambda {
      response.should have_rjs(:insert_html, "test2")
    }.should_fail
  end

  specify "should find rjs using :insert (positioned)" do
    render_rjs do |page|
      page.insert_html :top, "test1", "<div id=\"1\">foo</div>"
      page.insert_html :bottom, "test2", "<div id=\"2\">bar</div>"
      page.insert_html :before, "test3", "<div id=\"3\">none</div>"
      page.insert_html :after, "test4", "<div id=\"4\">loopy</div>"
    end
    response.should have_rjs(:insert, :top) {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#1")
    }
    response.should have_rjs(:insert, :top, "test1") {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#1")
    }
    lambda {
      response.should have_rjs(:insert, :top, "test2")
    }.should_fail
    response.should have_rjs(:insert, :bottom) {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#2")
    }
    response.should have_rjs(:insert, :bottom, "test2") {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#2")
    }
    response.should have_rjs(:insert, :before) {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#3")
    }
    response.should have_rjs(:insert, :before, "test3") {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#3")
    }
    response.should have_rjs(:insert, :after) {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#4")
    }
    response.should have_rjs(:insert, :after, "test4") {|rjs|
      rjs.should have_tag("div", 1)
      rjs.should have_tag("#4")
    }
  end
# 
# 
#   #
#   # Test assert_select_feed and assert_select_encoded
#   #
# 
#   def test_feed_versions
#     # Atom 1.0.
#     render_xml %Q{<feed xmlns="http://www.w3.org/2005/Atom"><title>test</title></feed>}
#     assert_nothing_raised               { assert_select_feed :atom }
#     assert_nothing_raised               { assert_select_feed :atom, 1.0 }
#     assert_raises(AssertionFailedError) { assert_select_feed :atom, 0.3 }
#     assert_raises(AssertionFailedError) { assert_select_feed :rss }
#     assert_select_feed(:atom, 1.0) { assert_select "feed>title", "test" }
#     # Atom 0.3.
#     render_xml %Q{<feed version="0.3"><title>test</title></feed>}
#     assert_nothing_raised               { assert_select_feed :atom, 0.3 }
#     assert_raises(AssertionFailedError) { assert_select_feed :atom }
#     assert_raises(AssertionFailedError) { assert_select_feed :atom, 1.0 }
#     assert_raises(AssertionFailedError) { assert_select_feed :rss }
#     assert_select_feed(:atom, 0.3) { assert_select "feed>title", "test" }
#     # RSS 2.0.
#     render_xml %Q{<rss version="2.0"><channel><title>test</title></channel></rss>}
#     assert_nothing_raised               { assert_select_feed :rss }
#     assert_nothing_raised               { assert_select_feed :rss, 2.0 }
#     assert_raises(AssertionFailedError) { assert_select_feed :rss, 0.92 }
#     assert_raises(AssertionFailedError) { assert_select_feed :atom }
#     assert_select_feed(:rss, 2.0) { assert_select "rss>channel>title", "test" }
#     # RSS 0.92.
#     render_xml %Q{<rss version="0.92"><channel><title>test</title></channel></rss>}
#     assert_nothing_raised               { assert_select_feed :rss, 0.92 }
#     assert_raises(AssertionFailedError) { assert_select_feed :rss }
#     assert_raises(AssertionFailedError) { assert_select_feed :rss, 2.0 }
#     assert_raises(AssertionFailedError) { assert_select_feed :atom }
#     assert_select_feed(:rss, 0.92) { assert_select "rss>channel>title", "test" }
#   end
# 
# 
#   def test_feed_item_encoded
#     render_xml <<-EOF
# <rss version="2.0">
#   <channel>
#     <item>
#       <description>
#         <![CDATA[
#           <p>Test 1</p>
#         ]]>
#       </description>
#     </item>
#     <item>
#       <description>
#         <![CDATA[
#           <p>Test 2</p>
#         ]]>
#       </description>
#     </item>
#   </channel>
# </rss>
# EOF
#     assert_select_feed :rss, 2.0 do
#       assert_select "channel item description" do
#         # Test element regardless of wrapper.
#         assert_select_encoded do
#           assert_select "p", :count=>2, :text=>/Test/
#         end
#         # Test through encoded wrapper.
#         assert_select_encoded do
#           assert_select "encoded p", :count=>2, :text=>/Test/
#         end
#         # Use :root instead (recommended)
#         assert_select_encoded do
#           assert_select ":root p", :count=>2, :text=>/Test/
#         end
#         # Test individually.
#         assert_select "description" do |elements|
#           assert_select_encoded elements[0] do
#             assert_select "p", "Test 1"
#           end
#           assert_select_encoded elements[1] do
#             assert_select "p", "Test 2"
#           end
#         end
#       end
#     end
#     # Test that we only un-encode element itself.
#     assert_select_feed :rss, 2.0 do
#       assert_select "channel item" do
#         assert_select_encoded do
#           assert_select "p", 0
#         end
#       end
#     end
#   end
# 
# 
#   #
#   # Test assert_select_email
#   #
# 
#   def test_assert_select_email
#     assert_raises(AssertionFailedError) { assert_select_email {} }
#     AssertSelectMailer.deliver_test "<div><p>foo</p><p>bar</p></div>"
#     assert_select_email do
#       assert_select "div:root" do
#         assert_select "p:first-child", "foo"
#         assert_select "p:last-child", "bar"
#       end
#     end
#   end

end
