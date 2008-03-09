require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/ar_classes'

describe "stub_model" do
  it "should have an id starting at 1000" do
    stub_model(MockableModel).id.should be >= 1000
  end
  
  it "should accept a stub id" do
    stub_model(MockableModel, :id => 3).id.should == 3
  end
  
  it "should accept a stub anything" do
    stub_model(MockableModel, :foo => "bar").foo.should == "bar"
  end
  
  it "should raise when hitting the db" do
    lambda do
      stub_model(MockableModel).save
    end.should raise_error(Spec::Rails::IllegalDataAccessException, /stubbed models are not allowed to access the database/)
  end
  
  it "should increment the id" do
    first = stub_model(MockableModel)
    second = stub_model(MockableModel)
    second.id.should == (first.id + 1)
  end
  
end

describe "stub_model as association", :type => :view do
  before(:each) do
    @real = AssociatedModel.create!
    @stub_model = stub_model(MockableModel)
    @real.mockable_model = @stub_model
  end
  
  it "should pass associated_model == mock" do
      @stub_model.should == @real.mockable_model
  end

  it "should pass mock == associated_model" do
      @real.mockable_model.should == @stub_model
  end
end

describe "stub_model with a block", :type => :view do
  it "should yield the stub" do
    model = stub_model(MockableModel) do |model|
      model.stub!(:foo).and_return(:bar)
    end
    model.foo.should == :bar
  end
end
