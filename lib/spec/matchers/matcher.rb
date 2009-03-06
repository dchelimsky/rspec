module Spec
  module Matchers
    class Matcher
      include InstanceExec
      
      def initialize(name, expected=nil, &block_passed_to_init)
        @name = name
        @expected = expected
        @block = block_passed_to_init
        @messages = {
          :description => lambda {"#{name_to_sentence} #{expected}"},
          :failure_message_for_should => lambda {|actual| "expected #{actual} to #{name_to_sentence} #{expected}"},
          :failure_message_for_should_not => lambda {|actual| "expected #{actual} not to #{name_to_sentence} #{expected}"}
        }
      end
      
      def matches?(actual)
        @actual = actual
        instance_exec @expected, &@block
        instance_exec @actual, &@match_block
      end
      
      def description(&block)
        cache_or_call_cached(:description, &block)
      end
      
      def failure_message_for_should(&block)
        cache_or_call_cached(:failure_message_for_should, @actual, &block)
      end
      
      def failure_message_for_should_not(&block)
        cache_or_call_cached(:failure_message_for_should_not, @actual, &block)
      end
      
      def match(&block)
        @match_block = block
      end
      
    private

      def cache_or_call_cached(key, actual=nil, &block)
        block ? @messages[key] = block :
                actual.nil? ? @messages[key].call :
                              @messages[key].call(actual)
      end
    
      def name_to_sentence
        @name_to_sentence ||= @name.to_s.gsub(/_/,' ')
      end
    
    end
  end
end