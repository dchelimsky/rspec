module Spec
  module Rails
    class ModelContext < Rails::Context
      def before_context_eval
        inherit Test::Rails::TestCase
      end
    end
  end
end

