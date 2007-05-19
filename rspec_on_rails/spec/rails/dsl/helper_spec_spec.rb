require File.dirname(__FILE__) + '/../../spec_helper'
Spec::Runner.configuration.global_fixtures = :people

describe "HelperBehaviour", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should have direct access to methods defined in helpers" do
    method_in_explicit_helper.should =~ /text from a method/
  end
end


describe "HelperBehaviour#eval_erb", :behaviour_type => :helper do
  helper_name :explicit
  
  it "should support methods that accept blocks" do
    eval_erb("<% prepend 'foo' do %>bar<% end %>").should == "foobar"
  end
end

describe "HelperBehaviour.fixtures", :behaviour_type => :helper do
  helper_name :explicit
  fixtures :animals

  it "loads fixtures" do
    pig = animals(:pig)
    pig.class.should == Animal
  end

  it "loads global fixtures" do
    lachie = people(:lachie)
    lachie.class.should == Person
  end  
end

describe ExplicitHelper, :behaviour_type => :helper do
  it "should not require naming the helper if describe is passed a type" do
    method_in_explicit_helper.should match(/text from a method/)
  end
end
