module Spec
  module Api
    # This module adds syntactic sugar that allows usage of should_* instead of should.*
    module Sugar
      module SugarizeForRspec; end

      def sugarize_for_rspec!
        original_method_missing = instance_method(:method_missing)
        class_eval do
          include SugarizeForRspec # This is meant to add a signiture to the object that sugarization occurred.
          def method_missing(sym, *args, &block)
            _method_missing(sym, args, block)
          end

          define_method :_method_missing do |sym, args, block|
            return original_method_missing.bind(self).call(sym, *args, &block) unless __is_sweetened?(sym)

            object = self
            calls = sym.to_s.split("_")
            while calls.length > 1
              if (object.respond_to?calls.join("_"))
                object.__send__(calls.join("_"), *args, &block)
                return
              else
                call = calls.shift
                object = object.__send__(call)
                break if call == "be" unless ["an_instance_of","a_kind_of"].include? calls[0]
              end
            end
            return object.__send__(calls.join("_"), *args, &block)
          end

          def __is_sweetened?(sym) #:nodoc:
            return true if sym.to_s =~ /^should_/
          end
        end
      end
    end
    
    module MessageExpectationSugar
      def __is_sweetened?(sym) #:nodoc:
        return true if sym.to_s =~ /^once_|^twice_/
      end
    end
  end
end

class Module
  include Spec::Api::Sugar
end

Object.sugarize_for_rspec!

class Spec::Api::MessageExpectation #:nodoc:
  include Spec::Api::MessageExpectationSugar
end