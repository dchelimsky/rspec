module Spec
  module Expectations
    module NumericExpectations
      def should_be_close(other, precision)
        should.be._close_for_rspec(other, precision)
      end

      private
      def _close_for_rspec?(other, precision)
        (self - other).abs < precision
      end
    end
  end
end

class Numeric
  include Spec::Expectations::NumericExpectations
end