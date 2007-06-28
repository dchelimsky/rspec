require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/mocks/errors'

describe ActionView::Base, "with RSpec extensions", :behaviour_type => :view do  
  it "should not raise when render has been received" do
    template.expects_render(:partial => "name")
    template.render :partial => "name"
  end
  
  it "should raise when render has NOT been received", :should_raise => [Spec::Mocks::MockExpectationError]  do
    template.expects_render(:partial => "name")
  end
  
  it "should not raise when stubbing and render has been received" do
    template.stubs_render(:partial => "name")
    template.render :partial => "name"
  end
  
  it "should not raise when stubbing and render has NOT been received" do
    template.stubs_render(:partial => "name")
  end
  
  it "should not raise when stubbing and render has been received with different options" do
    template.stubs_render(:partial => "different_name")
  end
end
