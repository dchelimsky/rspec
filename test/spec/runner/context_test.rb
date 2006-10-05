require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def setup
        @formatter = Spec::Mocks::Mock.new "formatter", :register_as_spec_listener => false
        @context = Context.new("context") {}
      end

      def teardown
        @formatter.__verify
      end
      
      def test_should_add_itself_to_formatter_on_run
        @formatter.should_receive(:add_context).with "context"
        @context.run(@formatter)
      end
      
      def test_should_run_spec
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test", :anything, :anything
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter)
        assert $spec_ran
      end
         
      def test_should_run_spec_dry
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test"
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter, true)
        assert !$spec_ran
      end
      
      def test_setup
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_setup_ran = false
        super_class = Class.new do
          define_method :setup do
            super_class_setup_ran = true
          end
        end
        @context.inherit super_class

        setup_ran = false
        @context.setup {setup_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        assert super_class_setup_ran
        assert setup_ran
      end

      def test_setup__should_allow_method_definitions
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        $method_in_setup_called = false
        @context.setup do
          def method_in_setup
            $method_in_setup_called = true
          end
        end

        @context.specify("test") {method_in_setup}
        @context.run(@formatter)

        assert $method_in_setup_called
      end

      def test_teardown
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_teardown_ran = false
        super_class = Class.new do
          define_method :teardown do
            super_class_teardown_ran = true
          end
        end
        @context.inherit super_class

        teardown_ran = false
        @context.teardown {teardown_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        assert super_class_teardown_ran
        assert teardown_ran
        @formatter.__verify
      end

      def test_inherit__superclass_methods_should_be_accessible
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        helper_method_ran = false
        super_class = Class.new do
          define_method :helper_method do
            helper_method_ran = true
          end
        end
        @context.inherit super_class

        @context.specify("test") {helper_method}
        @context.run(@formatter)
        assert helper_method_ran
      end

      def test_inherit__class_methods_should_work
        class_method_ran = false
        super_class = Class.new
        (class << super_class; self; end).class_eval do
          define_method :class_method do
            class_method_ran = true
          end
        end
        @context.inherit super_class
        @context.class_method
        assert class_method_ran

        assert_raise(NoMethodError) {@context.foobar}
      end

      def test_methods__should_include_inherited_class_methods
        class_method_ran = false
        super_class = Class.new
        class << super_class
          def super_class_class_method; end
        end
        @context.inherit super_class

        assert @context.methods.include?("super_class_class_method")
      end

      def test_include
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        mod1_method_called = false
        mod1 = Module.new do
          define_method :mod1_method do
            mod1_method_called = true
          end
        end

        mod2_method_called = false
        mod2 = Module.new do
          define_method :mod2_method do
            mod2_method_called = true
          end
        end

        @context.include mod1
        @context.include mod2

        @context.specify("test") do
          mod1_method
          mod2_method
        end
        @context.run(@formatter)
        assert mod1_method_called
        assert mod2_method_called
      end
      
      def test_spec_count_1
        @context.specify("test") {}
        assert_equal(1, @context.number_of_specs)
      end
      
      def test_spec_count_4
        @context.specify("one") {}
        @context.specify("two") {}
        @context.specify("three") {}
        @context.specify("four") {}
        assert_equal(4, @context.number_of_specs)
      end
    end
  end
end