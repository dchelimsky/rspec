require File.dirname(__FILE__) + '/../spec_helper'

context "Given any template, a 'should_have_tag' expectation with",
  :context_type => :view do
    
  specify "angle brackets should raise with a useful warning" do
    render "tag_spec/no_tags"
    message = %-

SyntaxError in should_have_tag(tag, *opts)
* tag should be the name of the tag (like 'div', or 'select' without '<' or '>')
* opts should be a Hash of key value pairs

-
    lambda { response.should_have_tag '<div>' }.should_raise Spec::Expectations::ExpectationNotMetError, message
  end
end

context "Given a template with no tags, a 'should_have_tag' expectation",
  :context_type => :view do
  
  specify "should fail" do
    render "tag_spec/no_tags"
    lambda { response.should_have_tag 'div'}.should_fail
  end
end

context "Given a template with one div tag with no attributes, a 'should_have_tag' expectation with",
  :context_type => :view do
  
  setup do
    render "tag_spec/single_div_with_no_attributes"
  end
  
  specify "'div' should pass" do
    response.should_have_tag 'div'
  end
  
  specify ":div should pass" do
    response.should_have_tag :div
  end
  
  specify "'div', :attributes => {:id => 'a'} should fail" do
    lambda { response.should_have_tag 'div', :attributes => {:id => 'a'} }.should_fail
  end
end

context "Given a template with one tag with one attribute, a 'should_have_tag' expectation with",
  :context_type => :view do
  
  setup do
    render "tag_spec/single_div_with_one_attribute"
  end
  
  specify "the right tag and no attributes should pass" do
    response.should_have_tag 'div'
  end
  
  specify "the right tag, attribute and value should pass" do
    response.should_have_tag 'div', :attributes => { :key => "value" }
  end
  
  specify "the right tag, attribute and matching regexp should pass" do
    response.should_have_tag 'div', :attributes => { :key => /alu/ }
  end
  
  specify "the right tag, attribute and non-matching regexp should fail" do
    lambda do 
      response.should_have_tag 'div', :attributes => { :key => /valued/ }
    end.should_fail
  end
  
  specify "the right tag and attribute but the wrong value should fail" do
    lambda do 
      response.should_have_tag 'div', :attributes => { :key => "wrong value" }
    end.should_fail
  end
  
  specify "that tag and value but the wrong attribute should fail" do
    lambda do 
      response.should_have_tag 'div', :attributes => { :wrong_key => "value" }
    end.should_fail
  end
end

