require File.dirname(__FILE__) + '/../../spec_helper'

module ActionController
  describe "Rescue", "#rescue_action" do
    before(:each) do
      @fixture = Object.new
      @fixture.extend ActionController::Rescue
      class << @fixture
        public :rescue_action
      end
    end

    it "should raise a the passed in exception so examples fail fast" do
      proc {@fixture.rescue_action(RuntimeError.new("Foobar"))}.should raise_error(RuntimeError, "Foobar")
    end

    it "should raise a the passed in MockExpectationError so examples fail fast" do
      proc {@fixture.rescue_action(Spec::Mocks::MockExpectationError.new("Foobar"))}.should raise_error(Spec::Mocks::MockExpectationError, "Foobar")
    end
  end
  
  class SearchController < ActionController::Base
    def rescue_action(error)
      "successfully overridden"
    end
  end

  describe "Rescue", "#rescue_action, when overridden" do
    before(:each) do
      @fixture = SearchController.new
    end

    it "should do whatever the overridden method does" do
      @fixture.rescue_action(RuntimeError.new("Foobar")).should == "successfully overridden"
    end
  end
end
