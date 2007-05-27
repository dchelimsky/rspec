module Spec
  module Matchers
    
    class Anything #:nodoc:
      def ==(other)
        true
      end
    end

    # Use this for mock argument constraints only.
    def anything
      Matchers::Anything.new
    end
  end
end
