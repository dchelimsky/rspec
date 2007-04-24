require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Configuration do
      setup do
        @config = Configuration.new
        @behaviour = mock("behaviour")
      end

      it "should default mock framework to rspec" do
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/rspec$/
      end

      it "should let you set rspec explicitly" do
        @config.mock_with(:rspec)
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/rspec$/
      end

      it "should let you set mocha" do
        @config.mock_with(:mocha)
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/mocha$/
      end

      it "should let you set flexmock" do
        @config.mock_with(:flexmock)
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/flexmock$/
      end
      
      it "should let you set an arbitrary path to a mock framework" do
        @config.mock_with("arbitrary/path")
        @config.mock_framework.should == "arbitrary/path"
      end
    end
  end
end