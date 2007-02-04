module Spec
  module Expectations
    module Matchers
      
      class Have #:nodoc:
        def initialize(expected, relativity=:exactly)
          @expected = (expected == :no ? 0 : expected)
          @relativity = relativity
        end
      
        def relativities
          @relativities ||= {
            :exactly => "",
            :at_least => "at least ",
            :at_most => "at most "
          }
        end
      
        def method_missing(sym, *args, &block)
          @sym = sym
          @args = args
          @block = block
          self
        end
      
        def matches?(collection_owner)
          collection = collection_owner.send(@sym, *@args, &@block)
          @actual = collection.length if collection.respond_to?(:length)
          @actual = collection.size if collection.respond_to?(:size)
          return @actual >= @expected if @relativity == :at_least
          return @actual <= @expected if @relativity == :at_most
          return @actual == @expected
        end
      
        def failure_message
          "expected #{relativities[@relativity]}#{@expected} #{@sym}, got #{@actual}"
        end

        def negative_failure_message
          if @relativity == :exactly
            return "expected target not to have #{@expected} #{@sym}, got #{@actual}"
          elsif @relativity == :at_most
            return <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_most(#{@expected}).#{@sym}
We recommend that you use this instead:
  should have_at_least(#{@expected + 1}).#{@sym}
EOF
          elsif @relativity == :at_least
            return <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_least(#{@expected}).#{@sym}
We recommend that you use this instead:
  should have_at_most(#{@expected - 1}).#{@sym}
EOF
          end
        end
      end

    end
  end
end