module Spec
  module Api
    # This module, which is included in Object and Spec::Api::Mock 
    # adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
      alias_method :__orig_method_missing, :method_missing
      def method_missing(method, *args, &block)
        if __is_sweetened? method
          object = self
          calls = method.to_s.split("_")
          while calls.length > 1
            object = object.__send__(calls.shift)
          end
          return object.__send__(calls.shift, *args, &block)
        end
        __orig_method_missing(method, *args, &block)
      end
      
      def __is_sweetened? name
        return true if name.to_s[0,7] == "should_"
      end
    end
    
    module MessageExpectationSugar
      def __is_sweetened? name
        return true if name.to_s[0,4] == "and_"
        return true if name.to_s[0,3] == "at_"
        return true if name.to_s[0,4] == "any_"
        return true if name.to_s[0,5] == "once_"
      end
    end
  end
end

class Object #:nodoc:
  include Spec::Api::Sugar
end

class Spec::Api::Mock #:nodoc:
  #NOTE: this resolves a bug introduced by Sugar in which setting to null_object causes mock to ignore everything, including specified messages
  def should_receive(sym, &block)
    return receive(sym, &block)
  end
end

class Spec::Api::MessageExpectation #:nodoc:
  include Spec::Api::MessageExpectationSugar
end