module Spec
  module Story
    class StepMatchers
      def initialize
        @matchers = Hash.new {|h, k| h[k] = []}
      end
      
      def find(type, name)
        @matchers[type].each do |matcher|
          return matcher if matcher.matches?(name)
        end
        return nil
      end
      
      def create_matcher(type, name, &block)
        matcher = StepMatcher.new(name, &block)
        @matchers[type] << matcher
        matcher
      end
    end
  end
end
