module Spec
  module Api
    # This module, which is included in Object and Spec::Api::Mock 
    # adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
      alias_method :__orig_method_missing, :method_missing
      def method_missing(method, *args, &block)
        return self.should.be.__send__("#{method.to_s.split('_be_')[1]}") if method.to_s =~ /^should_be_/
        return self.should.not.be.__send__("#{method.to_s.split('_be_')[1]}") if method.to_s =~ /^should_not_be_/
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
      
      def __is_sweetened? sym
        return true if sym.to_s =~ /^should_/
      end
    end
    
    module MessageExpectationSugar
      def __is_sweetened? sym
        return true if sym.to_s =~ /^and_|^at_|^any_|^once_/
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