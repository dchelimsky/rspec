require 'spec/expectations/matchers/be'
require 'spec/expectations/matchers/be_close'
require 'spec/expectations/matchers/eql'
require 'spec/expectations/matchers/equal'
require 'spec/expectations/matchers/have'
require 'spec/expectations/matchers/include'
require 'spec/expectations/matchers/match'
require 'spec/expectations/matchers/satisfy'

module Spec
  module Expectations
    module Matchers
      
      #passes if actual.equal?(expected)
      def equal(expected)
        Matchers::Equal.new(expected)
      end
      
      #passes if actual.eql?(expected)
      def eql(expected)
        Matchers::Eql.new(expected)
      end
      
      #passes if actual == expected +/- delta
      def be_close(expected, delta)
        Matchers::BeClose.new(expected, delta)
      end

      #actual.should have(n).items
      #
      #passes if actual owns a collection named 'items'
      #which contains n elements
      def have(n)
        Matchers::Have.new(n)
      end
      alias :have_exactly :have
    
      #actual.should have_at_least(n).items
      #
      #passes if actual owns a collection named 'items'
      #which contains at least n elements
      def have_at_least(n)
        Matchers::Have.new(n, :at_least)
      end
    
      #actual.should have_at_most(n).items
      #
      #passes if actual owns a collection named 'items'
      #which contains at most n elements
      def have_at_most(n)
        Matchers::Have.new(n, :at_most)
      end
      
      def include(expected)
        Matchers::Include.new(expected)
      end
      
      def be(expected)
        Matchers::Be.new(expected)
      end
      
      def match(regexp)
        Matchers::Match.new(regexp)
      end
      
      def satisfy(&block)
        Matchers::Satisfy.new(&block)
      end

    end
    
    class Matcher
      include Matchers
    end
  end      
end