require File.dirname(__FILE__) + '/../spec_helper.rb'

module Spec
  describe Runner do
    describe ".configure" do
      it "should yield global configuration" do
        Spec::Runner.configure do |config|
          config.should equal(Spec::Runner.configuration)
        end
      end
    end
  end

  describe "when ::Test is absent during loading but present when running exit?" do
    # believe it or not, this can happen when ActiveSupport is loaded after RSpec is, 
    # since it loads active_support/core_ext/test/unit/assertions.rb which defines
    # Test::Unit but doesn't actually load test/unit

    before(:each) do
      Object.const_set(:Test, Module.new)
    end
    
    it "does not attempt to access the non-loaded test/unit library" do
      Spec::Runner.test_unit_defined?.should be_false
    end
    
    after(:each) do
      Object.send(:remove_const, :Test)
    end
  end
end
