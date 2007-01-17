module Spec
  module Expectations
    module Matchers
      class Be
        def initialize(expected)
          @expected = expected
        end
        
        def met_by?(target)
          @target = target
          return true if target.equal?(@expected) unless handling_predicate?
          return target.__send__(predicate) if target.respond_to?(predicate)
          return false
        end
        
        def failure_message
          return "expected #{@expected.inspect}, got #{@target.inspect}" unless handling_predicate?
          return "target does not respond to :#{predicate}" unless @target.respond_to?(predicate)
          return "expected target to respond to :#{predicate} with true"
        end
        
        def negative_failure_message
          return "expected not #{@expected.inspect}, got #{@target.inspect}" unless handling_predicate?
          return "target does not respond to :#{predicate}" unless @target.respond_to?(predicate)
          return "expected target to respond to :#{predicate} with false"
        end
        
        private
          def predicate
            "#{@expected.to_s}?".to_sym
          end
          
          def handling_predicate?
            return @expected.is_a?(Symbol)
          end
      end
    end
  end
end