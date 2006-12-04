require File.dirname(__FILE__) + '/../spec_helper'

context "Given an rjs call, a 'should_not_render_rjs' spec with",
  :context_type => :controller do
  controller_name :rjs_spec
  
  setup do
    post 'render_replace_html'
  end
  
  specify "the correct element name and exact text should fail" do
    lambda {
      controller.should_not_render_rjs :replace_html, 'mydiv', 'replacement text'
    }.should_fail
  end
  
  specify "the correct element name and a matching regexp should fail" do
    lambda {
      controller.should_not_render_rjs :replace_html, 'mydiv', /acement\ste/
    }.should_fail
  end
  
  specify "the correct element name but wrong text should pass" do
    controller.should_not_render_rjs :replace_html, 'mydiv', 'wrong replacement text'
  end
  
  specify "the correct element name but non-matching regexp text should pass" do
    controller.should_not_render_rjs :replace_html, 'mydiv', /wrong expression/
  end
  
  specify "the correct text but wrong element name should pass" do
    controller.should_not_render_rjs :replace_html, 'wrongname', 'replacement text'
  end
  
  specify "a matching regexp but wrong element name should pass" do
    controller.should_not_render_rjs :replace_html, 'wrongname', /acement/
  end
end

context "Given an rjs call to hide a div using page['id'], a 'should_not_render_rjs' spec with",
  :context_type => :controller do
  controller_name :rjs_spec
  
  setup do
    post 'render_hide_page_element'
  end
  
  specify "the correct element name should fail" do
    lambda {
      controller.should_not_render_rjs :page, 'mydiv', :hide
    }.should_fail
  end
  
  specify "the wrong element name should pass" do
    controller.should_not_render_rjs :page, 'wrongname', :hide
  end
  
  specify "the correct element name but wrong action should pass" do
    controller.should_not_render_rjs :page, 'mydiv', :replace
  end
end

