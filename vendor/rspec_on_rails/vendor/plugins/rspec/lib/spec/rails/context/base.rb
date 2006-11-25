module Spec
  module Rails
    class EvalContext < Test::Unit::TestCase
      undef_method :default_test
    end

    class Context < Spec::Runner::Context
    end
  end
end