require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class BacktraceTweakerTest < Test::Unit::TestCase
      def setup
        @error = RuntimeError.new
        @tweaker = BacktraceTweaker.new
      end
      
      def test_should_not_barf_on_nil_backtrace
        proc { @tweaker.tweak_backtrace @error, 'spec name' }.should.not.raise
      end
      
      def test_should_remove___instance_exec
        @error.set_backtrace ["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace[0].should.equal "./examples/airport_spec.rb:28:in `spec name'"
      end

      def test_should_replace_mock_method_missing_with_mock_name
        @error.set_backtrace ["/usr/local/lib/ruby/gems/1.8/gems/rspec-0.5.2/lib/spec/api/mock.rb:46:in `method_missing'"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should.be.empty
      end
      
      def test_should_remove_helpers
        @error.set_backtrace ["/lib/spec/api/helper/any_helper.rb"]
        @tweaker.tweak_backtrace @error, 'spec name'
        @error.backtrace.should.be.empty
      end
    end
  end
end