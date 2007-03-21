require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    class Configuration
    end
    describe Configuration do
      it "should default mock framework to rspec" do
        Spec::Runner::Configuration.new.mock_framework.should == :rspec
      end
      it "should let you set the mock framework" do
        Spec::Runner.configure do |config|
          config.mock_with :other_framework
        end
        Spec::Runner::configuration.mock_framework.should == :other_framework
      end
    end
  end
end