module Spec
  module Expectations
    module Matchers
      
      class Be #:nodoc:
        def initialize(expected, *args)
          @expected = expected
          @args = args
        end
        
        def matches?(actual)
          @actual = actual
          return true if actual.equal?(@expected) unless handling_predicate?
          return actual.__send__(predicate, *@args) if actual.respond_to?(predicate)
          return false
        end
        
        def failure_message
          return "expected #{@expected.inspect}, got #{@actual.inspect}" unless handling_predicate?
          return "actual does not respond to ##{predicate}" unless @actual.respond_to?(predicate)
          return "expected actual.#{predicate}#{args_to_s} to return true, got false"
        end
        
        def negative_failure_message
          return "expected not #{@expected.inspect}, got #{@actual.inspect}" unless handling_predicate?
          return "actual does not respond to ##{predicate}" unless @actual.respond_to?(predicate)
          return "expected actual.#{predicate}#{args_to_s} to return false, got true"
        end
        
        private
          def predicate
            "#{@expected.to_s}?".to_sym
          end
          
          def args_to_s
            return "" if @args.empty?
            transformed_args = @args.collect{|a| a.inspect}
            return "(#{transformed_args.join(', ')})"
          end
          
          def handling_predicate?
            return @expected.is_a?(Symbol)
          end
      end
   
    end
  end
end