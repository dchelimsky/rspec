require 'spec/expectations/matchers/collections'
require 'spec/expectations/matchers/equality'
require 'spec/expectations/matchers/numeric'
require 'spec/expectations/matchers/include'
require 'spec/expectations/matchers/be'

module Spec
  module Expectations
    module MatcherMethods
      
      #passes if receiver.equal?(expected)
      def equal(other)
        Matchers::Equal.new(other)
      end
      
      #passes if receiver.eql?(expected)
      def eql(other)
        Matchers::Eql.new(other)
      end
      
      def be_close(expected, delta)
        Matchers::BeClose.new(expected, delta)
      end

      def have(n)
        Matchers::Have.new(n)
      end
    
      def have_exactly(n)
        Matchers::Have.new(n)
      end
    
      def have_at_least(n)
        Matchers::Have.new(n, :at_least)
      end
    
      def have_at_most(n)
        Matchers::Have.new(n, :at_most)
      end
      
      def include(expected)
        Matchers::Include.new(expected)
      end
      
      def be(expected)
        Matchers::Be.new(expected)
      end

    end
    
    class Matcher
      include MatcherMethods
    end
  end      
end