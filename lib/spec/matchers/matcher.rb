module Spec
  module Matchers
    class Matcher
      include InstanceExec
      
      def initialize(name, expected=nil, &block_passed_to_init)
        @expected = expected
        @block = block_passed_to_init
        # FIXME - the next line has a hard coded description (ish)
        @description = lambda { "be a multiple of #{expected}" }
        @failure_message_for_should = lambda do |actual|
          "expected #{actual} to be a multiple of #{expected}"
        end
        @failure_message_for_should_not = lambda do |actual|
          "expected #{actual} not to be a multiple of #{expected}"
        end
      end
      
      def matches?(actual)
        @actual = actual
        instance_exec @expected, &@block
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
        instance_exec @actual, &block_passed_to_match
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
    
    end
  end
end