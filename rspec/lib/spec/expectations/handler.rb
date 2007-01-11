module Spec
  module Expectations
    class ExpectationHandler

      def initialize(target, expectation=nil)
        unless expectation.nil?
          unless expectation.met_by?(target)
            Spec::Expectations.fail_with(expectation.failure_message)
          end
        end
      end

    end

    class NegativeExpectationHandler
    
      def initialize(target, expectation=nil)
        unless expectation.nil?
          if expectation.met_by?(target)
            Spec::Expectations.fail_with(expectation.negative_failure_message)
          end
        end
      end
    
    end

  end
end

