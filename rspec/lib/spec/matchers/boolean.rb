module Spec
  module Matchers
    
    class Boolean #:nodoc:
      def ==(other)
        other.class == TrueClass || other.class == FalseClass
      end
    end

    # Use this for mock argument constraints only.
    def boolean
      Matchers::Boolean.new
    end
  end
end
