require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Configuration, :shared => true do
      before(:each) { @config = Configuration.new }
    end

    describe Configuration, "#use_transactional_fixtures" do
      it_should_behave_like "Spec::DSL::Configuration"
      
      it "should default to true" do
        @config.use_transactional_fixtures.should be(true)
      end

      it "should set to false" do
        @config.use_transactional_fixtures = false
        @config.use_transactional_fixtures.should be(false)
      end

      it "should set to true" do
        @config.use_transactional_fixtures = true
        @config.use_transactional_fixtures.should be(true)
      end
    end

    describe Configuration, "#use_instantiated_fixtures" do
      it_should_behave_like "Spec::DSL::Configuration"
      
      it "should to false" do
        @config.use_instantiated_fixtures.should be(false)
      end

      it "should set to false" do
        @config.use_instantiated_fixtures = false
        @config.use_instantiated_fixtures.should be(false)
      end

      it "should set to true" do
        @config.use_instantiated_fixtures = true
        @config.use_instantiated_fixtures.should be(true)
      end
    end

    describe Configuration, "#fixture_path" do
      it_should_behave_like "Spec::DSL::Configuration"
      
      it "should default to RAILS_ROOT + '/spec/fixtures'" do
        @config.fixture_path.should == RAILS_ROOT + '/spec/fixtures'
      end

      it "should set fixture_path" do
        @config.fixture_path = "/new/path"
        @config.fixture_path.should == "/new/path"
      end
    end

    describe Configuration, "#global_fixtures" do
      it_should_behave_like "Spec::DSL::Configuration"
      
      it "should default to []" do
        @config.global_fixtures.should == []
      end

      it "should set to false" do
        @config.global_fixtures << :blah
        @config.global_fixtures.should == [:blah]
      end
    end
  end
end
