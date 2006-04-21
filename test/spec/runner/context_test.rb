require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def setup
        @listener = Api::Mock.new "listener"
        @context = Context.new("context") {}
      end
      
      def test_should_add_itself_to_listener_on_run
        @listener.should.receive(:add_context).with "context"
        @context.run(@listener)
        @listener.__verify
      end
      
      def test_should_add_itself_to_listener_on_run_docs
        @listener.should.receive(:add_context).with "context"
        @context.run_docs(@listener)
        @listener.__verify
      end
      
      def test_spec
        @listener.should.receive(:add_context).with :any_args
        @listener.should.receive(:add_spec).with "test", :anything, :anything
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@listener)
        assert $spec_ran
        @listener.__verify
      end     
         
      def test_spec_doc
        @listener.should.receive(:add_context).with :any_args
        @listener.should.receive(:add_spec).with "test"
        @context.specify("test") {}
        @context.run_docs(@listener)
        assert $spec_ran
        @listener.__verify
      end
      
      def test_setup
        @listener.should.receive(:add_context).with :any_args
        @listener.should.receive(:add_spec).with :any_args
        $setup_ran = false
        @context.setup {$setup_ran = true}
        @context.specify("test") {true}
        @context.run(@listener)
        assert $setup_ran
        @listener.__verify
      end

      def test_teardwown
        @listener.should.receive(:add_context).with :any_args
        @listener.should.receive(:add_spec).with :any_args
        $teardwown_ran = false
        @context.teardown {$teardwown_ran = true}
        @context.specify("test") {true}
        @context.run(@listener)
        assert $teardwown_ran
        @listener.__verify
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