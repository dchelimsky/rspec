module Spec
  module Expectations
    # deprecated
    module NumericExpectationsExtension
      # Passes if receiver is less than +-delta away from other
      def should_be_close(other, delta)
        should.be._close_for_rspec(other, delta)
      end

      private
      def _close_for_rspec?(other, delta)
        (self - other).abs < delta
      end
    end
  end
end

# deprecated
class Numeric
  include Spec::Expectations::NumericExpectationsExtension
end