require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class BacktraceTweakerTest < Test::Unit::TestCase
      def setup
        @error = RuntimeError.new
        @tweaker = NoisyBacktraceTweaker.new
      end
      
      def test_should_not_barf_on_nil_backtrace
        proc { @tweaker.tweak_backtrace @error, 'spec name' }.should.not.raise
      end
      
      def test_should_replace___instance_exec_with_spec_name
        @error.set_backtrace ["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace[0].should_equal "./examples/airport_spec.rb:28:in `spec name'"
      end

      def test_should_leave_anything_in_api_dir_in_full_backtrace_mode
        @error.set_backtrace ["/lib/spec/api/anything.rb"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace[0].should_equal "/lib/spec/api/anything.rb"
      end
      
      def test_should_leave_anything_in_runner_dir_in_full_backtrace_mode
        @error.set_backtrace ["/lib/spec/runner/anything.rb"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_not_be_empty
      end
      
      def test_should_leave_bin_spec
        @error.set_backtrace ["bin/spec:"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_not_be_empty
      end
      
    end

    class QuietBacktraceTweakerTest < Test::Unit::TestCase
      def setup
        @error = RuntimeError.new
        @tweaker = QuietBacktraceTweaker.new
      end
      
      def test_should_not_barf_on_nil_backtrace
        proc { @tweaker.tweak_backtrace @error, 'spec name' }.should.not.raise
      end
      
      def test_should_replace___instance_exec_with_spec_name
        @error.set_backtrace ["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace[0].should_equal "./examples/airport_spec.rb:28:in `spec name'"
      end

      def test_should_remove_anything_in_api_dir
        @error.set_backtrace ["/lib/spec/api/anything.rb"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_be_empty
      end

      def test_should_remove_anything_in_runner_dir
        @error.set_backtrace ["/lib/spec/runner/anything.rb"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_be_empty
      end

      def test_should_remove_anything_from_textmate_ruby_bundle
        @error.set_backtrace ["/Applications/TextMate.app/Contents/SharedSupport/Bundles/Ruby.tmbundle/Support/tmruby.rb:147"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_be_empty
      end

      def test_should_remove_bin_spec
        @error.set_backtrace ["bin/spec:"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should_be_empty
      end

    end
  end
end