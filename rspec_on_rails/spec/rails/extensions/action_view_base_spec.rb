require File.dirname(__FILE__) + '/../../spec_helper'

describe ActionView::Base, "with RSpec extensions", :behaviour_type => :view do  
  it "should not raise when partial has been received" do
    template.expect_partial("name")
    template.render :partial => "name"
    template.verify_expected_partials
  end
  
  it "should raise when partial has been received" do
    lambda do
      template.expect_partial("name")
      template.verify_expected_partials
    end.should raise_error(Spec::Mocks::MockExpectationError)
  end
end
