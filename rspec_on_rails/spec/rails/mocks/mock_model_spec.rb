require File.dirname(__FILE__) + '/../../spec_helper'

class MockableModel < ActiveRecord::Base
  has_one :associated_model
end

class SubMockableModel < MockableModel
end

class AssociatedModel < ActiveRecord::Base
  belongs_to :mockable_model
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
    @model.unmocked_method.should equal(@model)
  end
end

describe "mock_model as association", :behaviour_type => :view do
  before(:each) do
    @pending_message = %{
      mock == association_proxy fails but reports odd messages like this one:
        Mock 'Book_1027' expected :store_with_privacy? with (#<Clip:0x1a9139c @name="Clip_1025">)
        but received it with (#<Clip:0x1a9139c @name="Clip_1025">)
      
      Note that both objects report themselves as instances of the model, but, in fact,
      both are lying! The expected is actually a mock and the actual is actually an AssociationProxy.
      
      We should try to figure out a way to get this to report the truth.
    }
    @real = MockableModel.create!
    @real.associated_model = @associated_mock_model = mock_model(AssociatedModel)
  end
  
  it "should pass associated_model == mock" do
    pending @pending_message do
      @associated_mock_model.should == @real.associated_model
    end
  end

  it "should pass mock == associated_model" do
    pending @pending_message do
      @real.associated_model.should == @associated_mock_model
    end
  end
end
