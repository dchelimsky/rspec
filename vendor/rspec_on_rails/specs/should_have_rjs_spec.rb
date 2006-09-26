require File.dirname(__FILE__) + '/spec_helper'

context "Given an rjs call to replace inner html in a div, a 'should_have_rjs' spec with" do
  controller_name :person
  
  setup do
    post 'a_replace_html_call'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :replace_html, 'mydiv', 'replacement text'
  end

  specify "the correct element name and a matching regex should pass" do
    response.should_have_rjs :replace_html, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name and no text should pass" do
    response.should_have_rjs :replace_html, 'mydiv'
  end
  
  specify "the correct element name but wrong text should fail" do
    response.should_not_have_rjs :replace_html, 'mydiv', 'wrong replacement text'
  end
  
  specify "the correct element name but non-matching regex text should fail" do
    response.should_not_have_rjs :replace_html, 'mydiv', /wrong expression/
  end
  
  specify "the correct text but wrong element name should fail" do
    response.should_not_have_rjs :replace_html, 'wrongname', 'replacement text'
  end
  
  specify "a matching regex but wrong element name should fail" do
    response.should_not_have_rjs :replace_html, 'wrongname', /acement/
  end
  
  specify "no text but wrong element name should fail" do
    response.should_not_have_rjs :replace_html, 'wrongname'
  end
end

context "Given an rjs call to insert html in a div, a 'should_have_rjs' spec with" do
  controller_name :person
  
  setup do
    post 'an_insert_html_call'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :insert_html, 'mydiv', 'replacement text'
  end
  
  specify "the correct element name and a matching regex should pass" do
    response.should_have_rjs :insert_html, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name and no text should pass" do
    response.should_have_rjs :insert_html, 'mydiv'
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'mydiv', 'wrong replacement text'
    }.should_fail
  end
  
  specify "the correct element name but non-matching regex text should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'mydiv', /wrong expression/
    }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :insert_html, 'wrongname', 'replacement text'
    }.should_fail
  end
  
  specify "a matching regex but wrong element name should fail" do
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

context "Given an rjs call to replace all text a div, a 'should_have_rjs' spec with" do
  controller_name :person
  
  setup do
    post 'a_replace_call'
  end
  
  specify "the correct element name and exact text should pass" do
    response.should_have_rjs :replace, 'mydiv', 'replacement text'
  end
  
  specify "the correct element name and a matching regex should pass" do
    response.should_have_rjs :replace, 'mydiv', /acement\ste/
  end
  
  specify "the correct element name and no text should pass" do
    response.should_have_rjs :replace, 'mydiv'
  end
  
  specify "the correct element name but wrong text should fail" do
    lambda {
      response.should_have_rjs :replace, 'mydiv', 'wrong replacement text'
    }.should_fail
  end
  
  specify "the correct element name but non-matching regex text should fail" do
    lambda {
      response.should_have_rjs :replace, 'mydiv', /wrong expression/
    }.should_fail
  end
  
  specify "the correct text but wrong element name should fail" do
    lambda {
      response.should_have_rjs :replace, 'wrongname', 'replacement text'
    }.should_fail
  end
  
  specify "a matching regex but wrong element name should fail" do
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

context "Given an rjs call to hide a div, a 'should_have_rjs' spec with" do
  controller_name :person
  
  setup do
    post 'hide_div'
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

context "Given an rjs call to hide a div using page['id'], a 'should_have_rjs' spec with" do
  controller_name :person
  
  setup do
    post 'hide_page_element'
  end
  
  specify "the correct element name should pass" do
    response.should_have_rjs :page, 'mydiv', :hide
  end
  
  specify "the wrong element name should fail" do
    lambda {
      response.should_have_rjs :page, 'wrongname', :hide
    }.should_fail
  end
end
