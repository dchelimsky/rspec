module Spec
  module Api
    # This module adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
      module SugarizeForRspec; end

      def sugarize_for_rspec!
        original_method_missing = instance_method(:method_missing)
        class_eval do
          include SugarizeForRspec # This is meant to add a signature to the object that sugarization occurred.
          def method_missing(sym, *args, &block)
            _method_missing(sym, args, block)
          end

          define_method :_method_missing do |sym, args, block|
            return original_method_missing.bind(self).call(sym, *args, &block) unless __is_sweetened?(sym)

            object = self
            calls = sym.to_s.split("_")
            while calls.length > 1
              break if (object.respond_to?calls.join("_"))
              call = calls.shift
              object = object.__send__(call)
              break if call == "be"
            end
            return object.__send__(calls.join("_"), *args, &block)
          end

          def __is_sweetened?(sym) #:nodoc:
            return true if sym.to_s =~ /^should_/
          end
        end
      end
    end
  end
end

class Module
  include Spec::Api::Sugar
end

Object.sugarize_for_rspec!