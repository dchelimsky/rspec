require File.dirname(__FILE__) + '/../spec_helper'

context "Given an rjs call, a 'should_render_rjs' spec with",
  :context_type => :controller do
  controller_name :rjs_spec
  
  setup do
    post 'render_replace_html'
  end
  
  specify "the correct element name and exact text should pass" do
    controller.should_render_rjs :replace_html, 'mydiv', 'replacement text'
  end

  specify "the other correct element name and exact text should pass" do
    controller.should_render_rjs :replace_html, 'myotherdiv', 'other replacement text'
  end

  specify "the correct element name and a matching regexp should pass" do
    controller.should_render_rjs :replace_html, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda { controller.should_render_rjs :replace_html, 'mydiv', 'wrong replacement text' }.should_fail
  end
  
  specify "the correct element name but non-matching regexp text should fail" do
    lambda { controller.should_render_rjs :replace_html, 'mydiv', /wrong expression/ }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda { controller.should_render_rjs :replace_html, 'wrongname', 'replacement text' }.should_fail
  end
  
  specify "a matching regexp but wrong element name should fail" do
    lambda { controller.should_render_rjs :replace_html, 'wrongname', /acement/ }.should_fail
  end
  
  specify "no text but wrong element name should fail" do
    lambda { controller.should_render_rjs :replace_html, 'wrongname' }.should_fail
  end
end

['isolation','integration'].each do |mode|
  context "Given an rjs call, a 'should_render_rjs' spec in a context in #{mode} mode, with",
    :context_type => :controller do
    controller_name :rjs_spec
    if mode == 'integration'
      integrate_views
    end
  
    specify "the correct partial should pass" do
      post 'render_replace_html_with_partial'
      controller.should_render_rjs :replace_html, 'mydiv', :partial => 'rjs_spec/replacement_partial'
    end
  
    specify "the incorrect partial should fail" do
      post 'render_replace_html_with_partial'
      lambda { controller.should_render_rjs :replace_html, 'mydiv', :partial => 'rjs_spec/wrong_replacement_partial' }
    end
  end
end

context "Given an rjs call to hide a div using page['id'], a 'should_have_rjs' spec with",
  :context_type => :controller do
  controller_name :rjs_spec
  
  setup do
    post 'render_hide_page_element'
  end
  
  specify "the correct element name should pass" do
    controller.should_render_rjs :page, 'mydiv', :hide
  end
  
  specify "the wrong element name should fail" do
    lambda {
      controller.should_render_rjs :page, 'wrongname', :hide
    }.should_fail
  end
end
