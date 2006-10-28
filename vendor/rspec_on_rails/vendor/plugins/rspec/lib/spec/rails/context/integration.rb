module Spec
  module Rails
    class IntegrationContext < Rails::Context
      def before_context_eval
        inherit ActionController::IntegrationTest
      end
    end
  end
end
