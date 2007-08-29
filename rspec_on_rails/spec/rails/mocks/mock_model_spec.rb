require File.dirname(__FILE__) + '/../../spec_helper'

class MockableModel < ActiveRecord::Base
end

class SubMockableModel < MockableModel
end

describe "mock_model", :behaviour_type => :view do
  before(:each) do
    @model = mock_model(SubMockableModel)
  end
  it "should say it is_a? if it is" do
    @model.is_a?(SubMockableModel).should be(true)
  end
  it "should say it is_a? if it's ancestor is" do
    @model.is_a?(MockableModel).should be(true)
  end
  it "should say it is kind_of? if it is" do
    @model.kind_of?(SubMockableModel).should be(true)
  end
  it "should say it is kind_of? if it's ancestor is" do
    @model.kind_of?(MockableModel).should be(true)
  end
  it "should say it is instance_of? if it is" do
    @model.instance_of?(SubMockableModel).should be(true)
  end
  it "should not say it instance_of? if it isn't, even if it's ancestor is" do
    @model.instance_of?(MockableModel).should be(false)
  end
end

describe "mock_model with null_object", :behaviour_type => :view do
  before(:each) do
    @model = mock_model(MockableModel, :null_object => true, :mocked_method => "mocked")
  end
  
  it "should be able to mock methods" do
    @model.mocked_method.should == "mocked"
  end
  it "should return itself to unmocked methods" do
    @model.unmocked_method.should == @model
  end
end
