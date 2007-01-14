require 'spec/expectations/matchers/collections'
require 'spec/expectations/matchers/equality'
require 'spec/expectations/matchers/numeric'

module Spec
  module Expectations
    module Matchers
      
      #passes if receiver.equal?(expected)
      def equal(other)
        Equality::Equal.new(other)
      end
      
      #passes if receiver.eql?(expected)
      def eql(other)
        Equality::Eql.new(other)
      end
      
      def be_close(expected, delta)
        Numeric::BeClose.new(expected, delta)
      end

      def have(n)
        Collections::Have.new(n)
      end
    
      def have_exactly(n)
        Collections::Have.new(n)
      end
    
      def have_at_least(n)
        Collections::Have.new(n, :at_least)
      end
    
      def have_at_most(n)
        Collections::Have.new(n, :at_most)
      end
    end
  end      
end