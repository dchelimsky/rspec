module Spec
  module Expectations
    module Matchers
      
      class Has #:nodoc:
        def initialize(sym, *args)
          @sym = sym
          @args = args
        end
        
        def matches?(target)
          @target = target
          return false unless target.respond_to?(predicate)
          return target.send(predicate, *@args)
        end
        
        def failure_message
          return "target does not respond to #has_key?" unless @target.respond_to?(predicate)
          "expected ##{predicate.to_s}(#{@args[0].inspect}) to return true, got false"
        end
        
        def negative_failure_message
          return "target does not respond to #has_key?" unless @target.respond_to?(predicate)
          "expected ##{predicate.to_s}(#{@args[0].inspect}) to return false, got true"
        end
        
        private
          def predicate
            "has_#{@sym.to_s}?".to_sym
          end
        
      end
   
    end
  end
end
