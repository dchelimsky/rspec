module Spec
  module Callback
    class CallbackContainer
      def initialize
        @callback_registry = Hash.new do |hash, key|
          hash[key] = Array.new
        end
      end

      def define(key, &callback)
        @callback_registry[key] << callback
      end

      def notify(key, *args, &error_handler)
        @callback_registry[key].collect do |callback|
          begin
            callback.call(*args)
          rescue Exception => e
            yield(e) if error_handler
          end
        end
      end
    end
  end
end