require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Configuration do
      setup do
        @config = Configuration.new
        @behaviour = mock("behaviour")
      end

      it "should default mock framework to rspec" do
        @config.mock_framework.should == :rspec
      end

      it "should let you set the mock framework" do
        @config.mock_with(:other_framework)
        @config.mock_framework.should == :other_framework
      end
    end
  end
end