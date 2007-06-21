module ActionController
  module Rescue
    protected
    def rescue_action(exception)
      raise exception
    end
  end
end