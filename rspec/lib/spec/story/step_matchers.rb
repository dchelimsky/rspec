module Spec
  module Story
    class StepMatchers
      
      def initialize
        @matchers = Hash.new {|h, k| h[k] = []}
        yield self if block_given?
      end
      
      def find(type, name)
        @matchers[type].each do |matcher|
          return matcher if matcher.matches?(name)
        end
        return nil
      end
      
      def given(name, &block)
        create_matcher(:given, name, &block)
      end
      
      def when(name, &block)
        create_matcher(:when, name, &block)
      end
      
      def then(name, &block)
        create_matcher(:then, name, &block)
      end
      
      def add(type, new_matchers)
        (@matchers[type] << new_matchers).flatten!
      end
      
      def add_to(other_matchers)
        [:given, :when, :then].each do |type|
          other_matchers.add(type, @matchers[type])
        end
      end
      
      def <<(other_matchers)
        other_matchers.add_to(self)
      end
      
      # TODO - make me private
      def create_matcher(type, name, &block)
        matcher = StepMatcher.new(name, &block)
        @matchers[type] << matcher
        matcher
      end
    end
  end
end
