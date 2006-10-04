module Spec
  module Expectations
    # This module adds syntactic sugar that allows usage of should_* instead of should.*
    module UnderscoreSugar
      def handle_underscores_for_rspec!
        original_method_missing = instance_method(:method_missing)
        class_eval do
          def method_missing(sym, *args, &block)
            _method_missing(sym, args, block)
          end

          define_method :_method_missing do |sym, args, block|
            return original_method_missing.bind(self).call(sym, *args, &block) unless __sweetened?(sym)

            object = self
            calls = sym.to_s.split("_")
            while calls.length > 1
              remainder = calls.join("_")
              break if (object.respond_to?(remainder))
              call = calls.shift
              object = object.__send__(call)
              break if call == "be"
            end
            return object.__send__(calls.join("_"), *args, &block)
          end

          def __sweetened?(sym) #:nodoc:
            return true if sym.to_s =~ /^should_/
          end
        end
      end
    end
  end
end

class Module
  include Spec::Expectations::UnderscoreSugar
end