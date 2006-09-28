module Spec
  module Expectations
    module ObjectExpectations
      def should
        ShouldHelper.new self
      end
    end
  end
end

class Object
  include Spec::Expectations::ObjectExpectations
end

class Numeric
  def close?(other, precision)
    (self - other).abs < precision
  end
end