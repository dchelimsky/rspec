require File.dirname(__FILE__) + '/../spec_helper'

context "Given an rjs call to :replace_html in a div, a 'should_not_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/replace_html'
  end
  
  specify "the correct element name and exact text should fail" do
    lambda {
      response.should_not_have_rjs :replace_html, 'mydiv', 'replacement text'
    }.should_fail
  end
  
  specify "the correct element name and a matching regexp should fail" do
    lambda {
      response.should_not_have_rjs :replace_html, 'mydiv', /acement\ste/
    }.should_fail
  end
  
  specify "the correct element name but wrong text should pass" do
    response.should_not_have_rjs :replace_html, 'mydiv', 'wrong replacement text'
  end
  
  specify "the correct element name but non-matching regexp text should pass" do
    response.should_not_have_rjs :replace_html, 'mydiv', /wrong expression/
  end
  
  specify "the correct text but wrong element name should pass" do
    response.should_not_have_rjs :replace_html, 'wrongname', 'replacement text'
  end
  
  specify "a matching regexp but wrong element name should pass" do
    response.should_not_have_rjs :replace_html, 'wrongname', /acement/
  end
  
  specify "no text but wrong element name should pass" do
    response.should_not_have_rjs :replace_html, 'wrongname'
  end
end

context "Given an rjs call to :insert_html in a div, a 'should_not_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/insert_html'
  end
  
  specify "the correct element name and exact text should fail" do
    lambda {
      response.should_not_have_rjs :insert_html, 'mydiv', 'replacement text'
    }.should_fail
  end
  
  specify "the correct element name and a matching regexp should fail" do
    lambda {
      response.should_not_have_rjs :insert_html, 'mydiv', /acement\ste/
    }.should_fail
  end
  
  specify "the correct element name but wrong text should pass" do
    response.should_not_have_rjs :insert_html, 'mydiv', 'wrong replacement text'
  end
  
  specify "the correct element name but non-matching regexp text should pass" do
    response.should_not_have_rjs :insert_html, 'mydiv', /wrong expression/
  end
  
  specify "the correct text but wrong element name should pass" do
    response.should_not_have_rjs :insert_html, 'wrongname', 'replacement text'
  end
  
  specify "a matching regexp but wrong element name should pass" do
    response.should_not_have_rjs :insert_html, 'wrongname', /acement/
  end
  
  specify "no text but wrong element name should pass" do
    response.should_not_have_rjs :insert_html, 'wrongname'
  end
end

context "Given an rjs call to :replace in a div, a 'should_not_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/replace'
  end
  
  specify "the correct element name and exact text should fail" do
    lambda {
      response.should_not_have_rjs :replace, 'mydiv', 'replacement text'
    }.should_fail
  end
  
  specify "the correct element name and a matching regexp should fail" do
    lambda {
      response.should_not_have_rjs :replace, 'mydiv', /acement\ste/
    }.should_fail
  end
  
  specify "the correct element name but wrong text should pass" do
    response.should_not_have_rjs :replace, 'mydiv', 'wrong replacement text'
  end
  
  specify "the correct element name but non-matching regexp text should pass" do
    response.should_not_have_rjs :replace, 'mydiv', /wrong expression/
  end
  
  specify "the correct text but wrong element name should pass" do
    response.should_not_have_rjs :replace, 'wrongname', 'replacement text'
  end
  
  specify "a matching regexp but wrong element name should pass" do
    response.should_not_have_rjs :replace, 'wrongname', /acement/
  end
  
  specify "no text but wrong element name should pass" do
    response.should_not_have_rjs :replace, 'wrongname'
  end
end

context "Given an rjs call to :hide a div, a 'should_not_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/hide_div'
  end
  
  specify "the correct element name should fail" do
    lambda {
      response.should_not_have_rjs :hide, 'mydiv'
    }.should_fail
  end
  
  specify "the wrong element name should pass" do
    response.should_not_have_rjs :hide, 'wrongname'
  end
end

context "Given an rjs call to :hide a div using page['id'], a 'should_not_have_rjs' spec with",
  :context_type => :view do
  
  setup do
    render 'rjs_spec/hide_page_element'
  end
  
  specify "the correct element name should fail" do
    lambda {
      response.should_not_have_rjs :page, 'mydiv', :hide
    }.should_fail
  end
  
  specify "the wrong element name should pass" do
    response.should_not_have_rjs :page, 'wrongname', :hide
  end

  
  specify "the correct element name but wrong action should pass" do
    response.should_not_have_rjs :page, 'mydiv', :replace
  end
end

context "Given an rjs call to :visual_effect, a 'should_not_have_rjs' spec with",
  :context_type => :view do
    
  setup do
    render 'rjs_spec/visual_effect'
  end
  
  specify "the correct element name should fail" do
    lambda {
      response.should_not_have_rjs :effect, :fade, 'mydiv'
    }.should_fail
  end
  
  specify "the wrong element name should pass" do
    response.should_not_have_rjs :effect, :fade, 'wrongname'
  end
  
  specify "the correct element but the wrong command should pass" do
    response.should_not_have_rjs :effect, :puff, 'mydiv'
  end
  
end
  
context "Given an rjs call to :visual_effect for a toggle, a 'should_not_have_rjs' spec with",
  :context_type => :view do
    
  setup do
    render 'rjs_spec/visual_toggle_effect'
  end
  
  specify "the correct element name should fail" do
    lambda {
      response.should_not_have_rjs :effect, :toggle_blind, 'mydiv'
    }.should_fail
  end
  
  specify "the wrong element name should pass" do
    response.should_not_have_rjs :effect, :toggle_blind, 'wrongname'
  end
  
  specify "the correct element but the wrong command should pass" do
    response.should_not_have_rjs :effect, :puff, 'mydiv'
  end
  
end
  