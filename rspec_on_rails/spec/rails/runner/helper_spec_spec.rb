require File.dirname(__FILE__) + '/../../spec_helper'


describe "HelperBehaviour", :context_type => :helper do
  helper_name :explicit
  
  it "should have direct access to methods defined in helpers" do
    method_in_explicit_helper.should =~ /text from a method/
  end
end


describe "HelperBehaviour#eval_erb", :context_type => :helper do
  helper_name :explicit
  
  it "should support methods that accept blocks" do
    eval_erb("<% prepend 'foo' do %>bar<% end %>").should == "foobar"
  end
end

describe ExplicitHelper, :context_type => :helper do
  it "should not require naming the helper if describe is passed a type" do
    method_in_explicit_helper.should match(/text from a method/)
  end
end
