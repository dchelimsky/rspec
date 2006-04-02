require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class BacktraceTweakerTest < Test::Unit::TestCase
      def test_should_not_barf_on_nil_backtrace
        error = RuntimeError.new
        tweaker = BacktraceTweaker.new
        proc { tweaker.tweak_backtrace error, 'spec name' }.should.not.raise
      end
      
      def test_should_remove___instance_exec
        error = RuntimeError.new
        error.set_backtrace ["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"]
        tweaker = BacktraceTweaker.new
        tweaker.tweak_backtrace error, 'spec name'
        error.backtrace[0].should.equal "./examples/airport_spec.rb:28:in `spec name'"
      end
    end
  end
end