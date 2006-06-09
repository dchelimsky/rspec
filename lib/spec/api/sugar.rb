module Spec
  module Api
    # This module adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
      alias_method :__orig_method_missing, :method_missing
      def method_missing(sym, *args, &block)
        if __is_sweetened? sym
          object = self
          calls = sym.to_s.split("_")
          while calls.length > 1
            call = calls.shift
            object = object.__send__(call)
            break if call == "be"
          end
          return object.__send__(calls.join("_"), *args, &block)
        end
        __orig_method_missing(sym, *args, &block)
      end
      
      def __is_sweetened?(sym) #:nodoc:
        return true if sym.to_s =~ /^should_/
      end
    end
    
    module MessageExpectationSugar
      def __is_sweetened?(sym) #:nodoc:
        return true if sym.to_s =~ /^and_|^at_|^any_|^once_/
      end
    end
  end
end

class Object #:nodoc:
  include Spec::Api::Sugar
end

class Spec::Api::Mock #:nodoc:
  # NOTE: this resolves a bug caused by a conflict between Sugar#method_missing and Mock#method_missing, specifically
  # when the mock is set null_object=>true. It would be nice to get rid of this.
  def should_receive(sym, &block)
    return receive(sym, &block)
  end
end

class Spec::Api::MessageExpectation #:nodoc:
  include Spec::Api::MessageExpectationSugar
end