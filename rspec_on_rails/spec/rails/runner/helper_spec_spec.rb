require File.dirname(__FILE__) + '/../../spec_helper'

describe ExplicitHelper, :context_type => :helper do
  it "should not require naming the helper if describe is passed a type" do
    method_in_explicit_helper.should match(/text from a method/)
  end
end

