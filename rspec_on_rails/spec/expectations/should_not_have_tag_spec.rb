require File.dirname(__FILE__) + '/../spec_helper'

context "Given a template with no tags, a 'should_not_have_tag' spec with",
  :context_type => :view do

  setup do
    render "tag_spec/no_tags"
  end
    
  specify "['div'] should pass" do
    response.should_not_have_tag 'div'
  end

  specify "['div', :attributes=>{:id=>'joe'}] should pass" do
    response.should_not_have_tag 'div', :attributes=>{:id=>'joe'}
  end
end

context "Given a template with one div tag with no attributes, a 'should_not_have_tag' expectation with",
  :context_type => :view do
  
  setup do
    render "tag_spec/single_div_with_no_attributes"
  end
  
  specify "['div'] should fail" do
    lambda { response.should_not_have_tag 'div' }.should_fail
  end
  
  specify "['div', :attributes=>{:id=>'x'}] should pass" do
    response.should_not_have_tag 'div', :attributes => {:id => 'x'}
  end
end
