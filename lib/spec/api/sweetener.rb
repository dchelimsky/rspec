module Spec
  module Api
    # This module, which is included in Object and
    # Spec::Api::Mock when <tt>--sweet</tt> is specified,
    # will allow usage of should_* instead of should.*
    module Sweetener
      alias_method :__orig_method_missing, :method_missing
      def method_missing(method, *args, &block)
        if method.to_s[0,7] == "should_"
          object = self
          calls = method.to_s.split("_")
          while calls.length > 1
            object = object.__send__(calls.shift)
          end
          return object.__send__(calls.shift, *args, &block)
        end
        __orig_method_missing(method, *args, &block)
      end
    end
  end
end

class Object #:nodoc:
  include Spec::Api::Sweetener
end

class Spec::Api::Mock #:nodoc:
  include Spec::Api::Sweetener
end