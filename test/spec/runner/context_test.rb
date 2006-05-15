require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def setup
        @formatter = Api::Mock.new "formatter"
        @context = Context.new("context") {}
      end
      
      def test_should_add_itself_to_formatter_on_run
        @formatter.should.receive(:add_context).with "context"
        @context.run(@formatter)
        @formatter.__verify
      end
      
      def test_should_run_spec
        @formatter.should.receive(:add_context).with :any_args
        @formatter.should.receive(:add_spec).with "test", :anything, :anything
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter)
        assert $spec_ran
        @formatter.__verify
      end     
         
      def test_should_run_spec_dry
        @formatter.should.receive(:add_context).with :any_args
        @formatter.should.receive(:add_spec).with "test"
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter, true)
        assert !$spec_ran
        @formatter.__verify
      end
      
      def test_setup
        @formatter.should.receive(:add_context).with :any_args
        @formatter.should.receive(:add_spec).with :any_args
        $setup_ran = false
        @context.setup {$setup_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        assert $setup_ran
        @formatter.__verify
      end

      def test_teardwown
        @formatter.should.receive(:add_context).with :any_args
        @formatter.should.receive(:add_spec).with :any_args
        $teardwown_ran = false
        @context.teardown {$teardwown_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        assert $teardwown_ran
        @formatter.__verify
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
      
      def test_matches_should_pass_if_matches_context_and_spec
        @context.specify("spec") {}
        assert @context.matches?("context spec")
      end
      
      def test_matches_should_fail_if_input_does_not_start_with_name
        assert !@context.matches?("contextual spec")
      end
      
      def test_matches_should_fail_if_input_does_not_include_valid_spec
        assert !@context.matches?("context spec")
      end
      
      def test_isolate_should_trim_specs
        @context.specify("spec1") {}
        @context.specify("spec2") {}
        @context.isolate "context spec1"
        assert_equal 1, @context.number_of_specs
      end
      
    end
  end
end