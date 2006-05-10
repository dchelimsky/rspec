module Spec
  module Api
    # This module, which is included in Object and Spec::Api::Mock 
    # adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
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
    
    module MessageExpectationSugar
      alias_method :__orig_method_missing, :method_missing
      def method_missing(method, *args, &block)
        if should_sweeten? method
          object = self
          calls = method.to_s.split("_")
          while calls.length > 1
            object = object.__send__(calls.shift)
          end
          return object.__send__(calls.shift, *args, &block)
        end
        __orig_method_missing(method, *args, &block)
      end
      
      def should_sweeten? name
        return true if name.to_s[0,4] == "and_"
        return true if name.to_s[0,3] == "at_"
        return true if name.to_s[0,4] == "any_"
        return true if name.to_s[0,5] == "once_"
        return false
      end
    end
  end
end

class Object #:nodoc:
  include Spec::Api::Sugar
end

class Spec::Api::Mock #:nodoc:
  include Spec::Api::Sugar
end

class Spec::Api::MessageExpectation
  include Spec::Api::MessageExpectationSugar
end