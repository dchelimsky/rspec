module Spec
  module Matchers
    class Matcher
      include InstanceExec
      
      def initialize(name, expected=nil, &block_passed_to_init)
        @name = name
        @expected = expected
        @block = block_passed_to_init
        # FIXME - the next line has a hard coded description (ish)
        @description = lambda { "#{name_to_sentence} #{expected}" }
        @failure_message_for_should = lambda do |actual|
          "expected #{actual} to #{name_to_sentence} #{expected}"
        end
        @failure_message_for_should_not = lambda do |actual|
          "expected #{actual} not to #{name_to_sentence} #{expected}"
        end
      end
      
      def matches?(actual)
        @actual = actual
        instance_exec @expected, &@block
        instance_exec actual, &@match_block
      end
      
      def description(&block)
        block ? set_description(block) : eval_description
      end
      
      def failure_message
        @failure_message_for_should.call(@actual)
      end
      
      def negative_failure_message
        @failure_message_for_should_not.call(@actual)
      end
      
      def match(&block_passed_to_match)
        @match_block = block_passed_to_match
      end
      
      def failure_message_for(should_or_should_not, &block)
        case should_or_should_not
        when :should
          @failure_message_for_should = block
        when :should_not
          @failure_message_for_should_not = block
        end
      end
      
    private

      def set_description(block)
        @description = block
      end
    
      def eval_description
        @description.call
      end

      def name_to_sentence
        @name_to_sentence ||= @name.to_s.gsub(/_/,' ')
      end
    
    end
  end
end