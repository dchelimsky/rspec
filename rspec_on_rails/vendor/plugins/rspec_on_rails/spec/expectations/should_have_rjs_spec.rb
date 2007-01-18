require File.dirname(__FILE__) + '/../spec_helper'

context "Given an rjs call to :replace_html in a div, a 'should_have_rjs' spec with", :context_type => :view do
  
  setup do
    render 'rjs_spec/replace_html'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :replace_html, 'mydiv', 'replacement text'
  end
  
  specify "the correct element name and a matching regexp should pass" do
      response.should_have_rjs :replace_html, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda {
      response.should_have_rjs :replace_html, 'mydiv', 'wrong replacement text'
    }.should_fail
  end
  
  specify "the correct element name but non-matching regexp text should fail" do
    lambda {
      response.should_have_rjs :replace_html, 'mydiv', /wrong expression/
    }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace_html, 'wrongname', 'replacement text'
    }.should_fail
  end
  
  specify "a matching regexp but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace_html, 'wrongname', /acement/
    }.should_fail
  end
  
  specify "no text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace_html, 'wrongname'
    }.should_fail
  end
end

context "Given an rjs call to :replace_html in a div with a partial, a 'should_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/replace_html_with_partial'
  end

  specify "the correct element name and the text from a partial" do
    response.should_have_rjs :replace_html, 'mydiv', 'This is the text in the replacement partial.'
  end

  specify "the correct element name and a regex matching the text from a partial" do
    response.should_have_rjs :replace_html, 'mydiv', /This is the text in the replacement partial/
  end
end

context "Given an rjs call to :insert_html in a div, a 'should_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/insert_html'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :insert_html, 'mydiv', 'replacement text'
  end
  
  specify "the correct element name and a matching regexp should pass" do
      response.should_have_rjs :insert_html, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'mydiv', 'wrong replacement text'
    }.should_fail
  end
  
  specify "the correct element name but non-matching regexp text should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'mydiv', /wrong expression/
    }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'wrongname', 'replacement text'
    }.should_fail
  end
  
  specify "a matching regexp but wrong element name should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'wrongname', /acement/
    }.should_fail
  end
  
  specify "no text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'wrongname'
    }.should_fail
  end
end

context "Given an rjs call to :replace in a div, a 'should_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/replace'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :replace, 'mydiv', 'replacement text'
  end
  
  specify "the correct element name and a matching regexp should pass" do
    response.should_have_rjs :replace, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda {
      response.should_have_rjs :replace, 'mydiv', 'wrong replacement text'
    }.should_fail
  end
  
  specify "the correct element name but non-matching regexp text should fail" do
    lambda {
      response.should_have_rjs :replace, 'mydiv', /wrong expression/
    }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace, 'wrongname', 'replacement text'
    }.should_fail
  end
  
  specify "a matching regexp but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace, 'wrongname', /acement/
    }.should_fail
  end
  
  specify "no text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace, 'wrongname'
    }.should_fail
  end
end

context "Given an rjs call to :hide a div, a 'should_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/hide_div'
  end
  
  specify "the correct element name should pass" do
    response.should_have_rjs :hide, 'mydiv'
  end
  
  specify "the wrong element name should fail" do
    lambda {
      response.should_have_rjs :hide, 'wrongname'
    }.should_fail
  end
end

context "Given an rjs call to :hide a div using page['id'], a 'should_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/hide_page_element'
  end
  
  specify "the correct element name should pass" do
    response.should_have_rjs :page, 'mydiv', :hide
  end
  
  specify "the wrong element name should fail" do
    lambda {
      response.should_have_rjs :page, 'wrongname', :hide
    }.should_fail
  end
  
  specify "the correct element but the wrong command should fail" do
    lambda {
      response.should_have_rjs :page, 'mydiv', :replace
    }.should_fail
  end
end

context "Given an rjs call to :visual_effect, a 'should_have_rjs' spec with",
  :context_type => :view do
    
  setup do
    render 'rjs_spec/visual_effect'
  end
  
  specify "the correct element name should pass" do
    response.should_have_rjs :effect, :fade, 'mydiv'
  end
  
  specify "the wrong element name should fail" do
    lambda {
      response.should_have_rjs :effect, :fade, 'wrongname'
    }.should_fail
  end
  
  specify "the correct element but the wrong command should fail" do
    lambda {
      response.should_have_rjs :effect, :puff, 'mydiv'
    }.should_fail
  end
  
end
  
context "Given an rjs call to :visual_effect for a toggle, a 'should_have_rjs' spec with",
  :context_type => :view do
    
  setup do
    render 'rjs_spec/visual_toggle_effect'
  end
  
  specify "the correct element name should pass" do
    response.should_have_rjs :effect, :toggle_blind, 'mydiv'
  end
  
  specify "the wrong element name should fail" do
    lambda {
      response.should_have_rjs :effect, :toggle_blind, 'wrongname'
    }.should_fail
  end
  
  specify "the correct element but the wrong command should fail" do
    lambda {
      response.should_have_rjs :effect, :puff, 'mydiv'
    }.should_fail
  end
  
end