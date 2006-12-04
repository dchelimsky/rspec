module Spec
  module Rails
    class EvalContext < Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)
    end

    class Context < Spec::Runner::Context
    end
  end
end