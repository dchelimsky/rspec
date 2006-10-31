module Spec
  module Callback
    def callbacks
      @callbacks ||= CallbackContainer.new
    end
    private :callbacks

    def define_callback(key, &callback)
      callbacks.define(key, &callback)
    end

    def notify_callbacks(key, *args, &error_handler)
      callbacks.notify(key, *args, &error_handler)
    end
  end
end
