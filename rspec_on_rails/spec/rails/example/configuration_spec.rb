require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe Configuration, :shared => true do
      before(:each) { @config = Configuration.new }
    end

    describe Configuration, "#use_transactional_fixtures" do
      it_should_behave_like "Spec::Example::Configuration"

      it "should return Test::Unit::TestCase.use_transactional_fixtures" do
        @config.use_transactional_fixtures.should == Test::Unit::TestCase.use_transactional_fixtures
      end

      it "should set Test::Unit::TestCase.use_transactional_fixtures to false" do
        Test::Unit::TestCase.should_receive(:use_transactional_fixtures=).with(false)
        @config.use_transactional_fixtures = false
      end

      it "should set Test::Unit::TestCase.use_transactional_fixtures to true" do
        Test::Unit::TestCase.should_receive(:use_transactional_fixtures=).with(true)
        @config.use_transactional_fixtures = true
      end
    end

    describe Configuration, "#use_instantiated_fixtures" do
      it_should_behave_like "Spec::Example::Configuration"

      it "should return Test::Unit::TestCase.use_transactional_fixtures" do
        @config.use_instantiated_fixtures.should == Test::Unit::TestCase.use_instantiated_fixtures
      end

      it "should set Test::Unit::TestCase.use_instantiated_fixtures to false" do
        Test::Unit::TestCase.should_receive(:use_instantiated_fixtures=).with(false)
        @config.use_instantiated_fixtures = false
      end

      it "should set Test::Unit::TestCase.use_instantiated_fixtures to true" do
        Test::Unit::TestCase.should_receive(:use_instantiated_fixtures=).with(true)
        @config.use_instantiated_fixtures = true
      end
    end

    describe Configuration, "#fixture_path" do
      it_should_behave_like "Spec::Example::Configuration"

      it "should default to RAILS_ROOT + '/spec/fixtures'" do
        @config.fixture_path.should == RAILS_ROOT + '/spec/fixtures'
        Test::Unit::TestCase.fixture_path.should == RAILS_ROOT + '/spec/fixtures'
      end

      it "should set fixture_path" do
        @config.fixture_path = "/new/path"
        @config.fixture_path.should == "/new/path"
        Test::Unit::TestCase.fixture_path.should == "/new/path"
      end
    end

    describe Configuration, "#global_fixtures" do
      it_should_behave_like "Spec::Example::Configuration"

      it "should set fixtures on TestCase" do
        Test::Unit::TestCase.should_receive(:fixtures).with(:blah)
        @config.global_fixtures = [:blah]
      end
    end
  end
end
