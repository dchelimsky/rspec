require File.dirname(__FILE__) + '/../../spec_helper'

describe "A shared view behaviour", :shared => true do
  it "should have some tag with some text" do
    response.should have_tag('div', 'This is text from a method in the ViewSpecHelper')
  end
end

describe "A view behaviour", :behaviour_type => :view do
  it_should_behave_like "A shared view behaviour"
  
  before(:each) do
    render "view_spec/implicit_helper"
  end
end
  
