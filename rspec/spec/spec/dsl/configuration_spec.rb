require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    ConfigurationSpec =
      describe Configuration, :shared => true do
        before(:each) do
          @config = Configuration.new
          @behaviour = mock("behaviour")
        end
      end
    
    describe Configuration, "#mock_with" do
      include ConfigurationSpec
      it "should default mock framework to rspec" do
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/rspec$/
      end

      it "should let you set rspec mocking explicitly" do
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

      it "should let you set rr" do
        @config.mock_with(:rr)
        @config.mock_framework.should =~ /\/plugins\/mock_frameworks\/rr$/
      end

      it "should let you set an arbitrary adapter module" do
        adapter = Module.new
        @config.mock_with(adapter)
        @config.mock_framework.should == adapter
      end
    end

    describe Configuration, "#include" do
      include ConfigurationSpec

      before do
        @original_configuration = Spec::Runner.configuration
        spec_configuration = @config
        Spec::Runner.instance_eval {@configuration = spec_configuration}
        @foobar_behaviour = Class.new(ExampleGroup)
        ExampleGroupFactory.register(:foobar, @foobar_behaviour)
      end

      after do
        original_configuration = @original_configuration
        Spec::Runner.instance_eval {@configuration = original_configuration}
        ExampleGroupFactory.reset!
      end

      it "should let you define modules to be included for a behaviour_type" do
        mod = Module.new
        @config.include mod, :behaviour_type => :foobar
        @foobar_behaviour.included_modules.should include(mod)
      end
    end

    ConfigurationCallbacksSpec =
      describe Configuration, " callbacks", :shared => true do
        before do
          @config = Configuration.new
          @special_behaviour = Class.new(ExampleGroup)
          @special_child_behaviour = Class.new(@special_behaviour)
          @nonspecial_behaviour = Class.new(ExampleGroup)
          ExampleGroupFactory.register(:special, @special_behaviour)
          ExampleGroupFactory.register(:special_child, @special_child_behaviour)
          ExampleGroupFactory.register(:non_special, @nonspecial_behaviour)
          @behaviour = @special_child_behaviour.describe "Special Example Group"
          @unselected_behaviour = Class.new(@nonspecial_behaviour).describe "Non Special Example Group"
        end

        after do
          ExampleGroupFactory.reset!
        end
      end

    describe Configuration, "#prepend_before" do
      include ConfigurationCallbacksSpec

      it "prepends the before block on all instances of the passed in behaviour_type" do
        order = []
        @config.prepend_before(:all) do
          order << :prepend__before_all
        end
        @config.prepend_before(:all, :behaviour_type => :special) do
          order << :special_prepend__before_all
        end
        @config.prepend_before(:all, :behaviour_type => :special_child) do
          order << :special_child_prepend__before_all
        end
        @config.prepend_before(:each) do
          order << :prepend__before_each
        end
        @config.prepend_before(:each, :behaviour_type => :special) do
          order << :special_prepend__before_each
        end
        @config.prepend_before(:each, :behaviour_type => :special_child) do
          order << :special_child_prepend__before_each
        end
        @config.prepend_before(:all, :behaviour_type => :non_special) do
          order << :special_prepend__before_all
        end
        @config.prepend_before(:each, :behaviour_type => :non_special) do
          order << :special_prepend__before_each
        end
        @behaviour.it "calls prepend_before" do
        end
        
        @behaviour.suite.run
        order.should == [
          :prepend__before_all,
          :special_prepend__before_all,
          :special_child_prepend__before_all,
          :prepend__before_each,
          :special_prepend__before_each,
          :special_child_prepend__before_each
        ]
      end
    end

    describe Configuration, "#append_before" do
      include ConfigurationCallbacksSpec

      it "calls append_before on the behaviour_type" do
        order = []
        @config.append_before(:all) do
          order << :append_before_all
        end
        @config.append_before(:all, :behaviour_type => :special) do
          order << :special_append_before_all
        end
        @config.append_before(:all, :behaviour_type => :special_child) do
          order << :special_child_append_before_all
        end
        @config.append_before(:each) do
          order << :append_before_each
        end
        @config.append_before(:each, :behaviour_type => :special) do
          order << :special_append_before_each
        end
        @config.append_before(:each, :behaviour_type => :special_child) do
          order << :special_child_append_before_each
        end
        @config.append_before(:all, :behaviour_type => :non_special) do
          order << :special_append_before_all
        end
        @config.append_before(:each, :behaviour_type => :non_special) do
          order << :special_append_before_each
        end
        @behaviour.it "calls append_before" do
        end

        @behaviour.suite.run
        order.should == [
          :append_before_all,
          :special_append_before_all,
          :special_child_append_before_all,
          :append_before_each,
          :special_append_before_each,
          :special_child_append_before_each
        ]
      end
    end

    describe Configuration, "#prepend_after" do
      include ConfigurationCallbacksSpec

      it "prepends the after block on all instances of the passed in behaviour_type" do
        order = []
        @config.prepend_after(:all) do
          order << :prepend__after_all
        end
        @config.prepend_after(:all, :behaviour_type => :special) do
          order << :special_prepend__after_all
        end
        @config.prepend_after(:all, :behaviour_type => :special) do
          order << :special_child_prepend__after_all
        end
        @config.prepend_after(:each) do
          order << :prepend__after_each
        end
        @config.prepend_after(:each, :behaviour_type => :special) do
          order << :special_prepend__after_each
        end
        @config.prepend_after(:each, :behaviour_type => :special) do
          order << :special_child_prepend__after_each
        end
        @config.prepend_after(:all, :behaviour_type => :non_special) do
          order << :special_prepend__after_all
        end
        @config.prepend_after(:each, :behaviour_type => :non_special) do
          order << :special_prepend__after_each
        end
        @behaviour.it "calls prepend_after" do
        end

        @behaviour.suite.run
        order.should == [
          :special_child_prepend__after_each,
          :special_prepend__after_each,
          :prepend__after_each,
          :special_child_prepend__after_all,
          :special_prepend__after_all,
          :prepend__after_all
        ]
      end
    end

    describe Configuration, "#append_after" do
      include ConfigurationCallbacksSpec

      it "calls append_after on the behaviour_type" do
        order = []
        @config.append_after(:all) do
          order << :append__after_all
        end
        @config.append_after(:all, :behaviour_type => :special) do
          order << :special_append__after_all
        end
        @config.append_after(:all, :behaviour_type => :special_child) do
          order << :special_child_append__after_all
        end
        @config.append_after(:each) do
          order << :append__after_each
        end
        @config.append_after(:each, :behaviour_type => :special) do
          order << :special_append__after_each
        end
        @config.append_after(:each, :behaviour_type => :special_child) do
          order << :special_child_append__after_each
        end
        @config.append_after(:all, :behaviour_type => :non_special) do
          order << :non_special_append_after_all
        end
        @config.append_after(:each, :behaviour_type => :non_special) do
          order << :non_special_append_after_each
        end
        @behaviour.it "calls append_after" do
        end

        @behaviour.suite.run
        order.should == [
          :special_child_append__after_each,
          :special_append__after_each,
          :append__after_each,
          :special_child_append__after_all,
          :special_append__after_all,
          :append__after_all
        ]
      end
    end
  end
end
