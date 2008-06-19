module Spec
  module Matchers
    class SimpleMatcher
      attr_writer :failure_message, :negative_failure_message, :description
      
      def initialize(description, &match_block)
        @description = description
        @match_block = match_block
      end

      def matches?(actual)
        @actual = actual
        @match_block.arity == 2 ?
          @match_block.call(@actual, self) :
          @match_block.call(@actual)
      end
      
      def description
        @description || explanation
      end

      def failure_message
        @failure_message || (@description.nil? ? explanation : %[expected #{@description.inspect} but got #{@actual.inspect}])
      end

      def negative_failure_message
        @negative_failure_message || (@description.nil? ? explanation : %[expected not to get #{@description.inspect}, but got #{@actual.inspect}])
      end

      def explanation
        "No description provided. See RDoc for simple_matcher()"
      end
    end
  
    # +simple_matcher()+ makes it easy for you to create your own custom
    # matchers in just a few lines of code when you don't need all the power
    # of a completely custom matcher object.
    #
    # The description argument will appear as part of any failure message.
    #
    # The match block can have arity of 1 or 2. The first argument will be the
    # given value. The second, if the block accepts it will be the matcher
    # itself, giving you access to set custom failure messages in favor of the
    # defaults.
    #
    # If you set custom messages, you don't have to pass the description
    # argument to the simple_matcher method, but you must then provide any
    # messages that might get invoked directly to the matcher (see Example
    # with custom messages, below)
    #
    # The match_block should return a boolean: true indicates a match, which
    # will pass if you use +should+ and fail if you use +should_not+. false
    # indicates no match, which will do the reverse: fail if you use +should+
    # and pass if you use +should_not+.
    #
    # == Example with default messages
    #
    # def be_even
    #   simple_matcher("an even number") { |given| given % 2 == 0 }
    # end
    #         
    # describe 2 do
    #   it "should be even" do
    #     2.should be_even
    #   end
    # end
    #
    # Given an odd number, this example would produce an error message stating
    # 'expected "an even number"", got 3'
    #
    # == Example with custom messages
    #
    # def rhyme_with(expected)
    #   simple_matcher do |given, matcher|
    #     matcher.description = "string rhymer"
    #     matcher.failure_message = "expected #{given.inspect} to rhyme with #{expected.inspect}"
    #     matcher.negative_failure_message = "expected #{given.inspect} not to rhyme with #{expected.inspect}"
    #     actual.rhymes_with? expected
    #   end
    # end
    #
    # describe "pecan" do
    #   it "should rhyme with 'be gone'" do
    #     nut = "pecan"
    #     reed.extend Rhymer
    #     reed.should rhyme_with("be gone")
    #   end
    # end
    #
    # The resulting failure message would be 'expected "pecan" to rhyme with
    # "be gone"'. (Grandma Rita would be proud!)
    def simple_matcher(description=nil, &match_block)
      SimpleMatcher.new(description, &match_block)
    end
  end
end