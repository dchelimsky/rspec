module Spec
  module Expectations
    module Matchers
      
      class RespondTo #:nodoc:
        def initialize(sym)
          @sym = sym
        end
        
        def matches?(target)
          return target.respond_to?(@sym)
        end
        
        def failure_message
          "expected target to respond to #{@sym.inspect}"
        end
        
        def negative_failure_message
          "expected target not to respond to #{@sym.inspect}"
        end
      end
      
    end
  end
end
