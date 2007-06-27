require File.dirname(__FILE__) + '/../../spec_helper'

describe ActionView::Base, "with RSpec extensions", :behaviour_type => :view do  
  it "should not raise when partial has been received" do
    template.expect_render(:partial => "name")
    template.render :partial => "name"
    template.verify_rendered
  end
  
  it "should raise when partial has been received" do
    template.expect_render(:partial => "name")
    lambda do
      template.verify_rendered
    end.should raise_error(Spec::Mocks::MockExpectationError)
  end
end
