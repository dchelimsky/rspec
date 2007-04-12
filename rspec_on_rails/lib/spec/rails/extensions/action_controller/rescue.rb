module ActionController
  module Rescue
    protected
    alias old_rescue_action rescue_action
    def rescue_action(exception)
      raise exception if exception.is_a?(Spec::Mocks::MockExpectationError)
      old_rescue_action(exception)
    end
  end
end
