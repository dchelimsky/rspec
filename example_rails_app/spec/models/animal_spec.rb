require File.dirname(__FILE__) + '/../spec_helper'

describe Animal do
  it "should create a dog the first time" do
    lambda do
      Animal.create! :name => 'Dog'
    end.should_not raise_error
  end

  it "should create a dog the second time because transactions should be working" do
    lambda do
      Animal.create! :name => 'Dog'
    end.should_not raise_error
  end
end
