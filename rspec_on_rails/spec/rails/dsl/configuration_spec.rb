require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Configuration do
      before(:each) { @config = Configuration.new }
      
      it "should default use_transactional_fixtures to true" do
        @config.use_transactional_fixtures.should be(true)
      end

      it "should let you set use_transactional_fixtures false" do
        @config.use_transactional_fixtures = false
        @config.use_transactional_fixtures.should be(false)
      end

      it "should let you set use_transactional_fixtures true" do
        @config.use_transactional_fixtures = true
        @config.use_transactional_fixtures.should be(true)
      end

      it "should default use_instantiated_fixtures to false" do
        @config.use_instantiated_fixtures.should be(false)
      end

      it "should let you set use_instantiated_fixtures false" do
        @config.use_instantiated_fixtures = false
        @config.use_instantiated_fixtures.should be(false)
      end

      it "should let you set use_instantiated_fixtures true" do
        @config.use_instantiated_fixtures = true
        @config.use_instantiated_fixtures.should be(true)
      end

      it "should default fixture_path to RAILS_ROOT + '/spec/fixtures'" do
        @config.fixture_path.should == RAILS_ROOT + '/spec/fixtures'
      end

      it "should let you set fixture_path false" do
        @config.fixture_path = "/new/path"
        @config.fixture_path.should == "/new/path"
      end

      it "should default global_fixtures to []" do
        @config.global_fixtures.should == []
      end

      it "should let you set global_fixtures false" do
        @config.global_fixtures << :blah
        @config.global_fixtures.should == [:blah]
      end

    end
  end
end
