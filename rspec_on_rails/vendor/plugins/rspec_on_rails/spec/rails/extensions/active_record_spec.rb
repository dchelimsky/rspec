require File.dirname(__FILE__) + '/../../spec_helper'

class Thing < ActiveRecord::Base
  validates_presence_of :name
end

context "A model" do
  specify "should tell you its required fields" do
    Thing.new.should have(1).error_on(:name)
  end
  
  specify "should tell you how many records it has" do
    Thing.should have(:no).records
    Thing.create(:name => "THE THING")
    Thing.should have(1).record
  end
end