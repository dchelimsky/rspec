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

      # :call-seq:
      #   should have(number).items
      #   should_not have(number).items
      #
      # Passes if actual owns a collection
      # which contains n elements
      #
      # == Example
      #
      #   # Passes if team.players.size == 11
      #   team.should have(11).players
      def have(n)
        Matchers::Have.new(n)
      end
      alias :have_exactly :have

      # :call-seq:
      #   should have_at_least(number).items
      #
      # Passes if actual owns a collection
      # which contains at least n elements
      #
      # == Example
      #
      #   # Passes if team.players.size >= 11
      #   team.should have_at_least(11).players
      #
      # == Warning
      #
      # +should_not+ +have_at_least+ is not supported
      def have_at_least(n)
        Matchers::Have.new(n, :at_least)
      end

      # :call-seq:
      #   should have_at_most(number).items
      #
      # Passes if actual owns a collection
      # which contains at most n elements
      #
      # == Example
      #
      #   # Passes if team.players.size <= 11
      #   team.should have_at_most(11).players
      #
      # == Warning
      #
      # +should_not+ +have_at_most+ is not supported
      def have_at_most(n)
        Matchers::Have.new(n, :at_most)
      end
    end
  end
end