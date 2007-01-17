module Spec
  module Expectations
    # rspec adds #should and #should_not to every Object (and,
    # implicitly, every Class).
    module ObjectExpectations
      
      # Supports the following expectations:
      #   receiver.should == expected #any value
      #     Passes if (receiver == expected)
      #
      #   receiver.should =~ expected #a regexp
      #     Passes if (receiver =~ expected), where expected
      #     is a Regexp.
      #
      # NOTE that this does NOT support receiver.should != expected.
      # Instead, use receiver.should_not == expected
      def should(matcher=nil)
        ExpectationHandler.new(self,matcher) if matcher
        Should::Should.new(self)
      end

      # Supports the following expectations:
      #   receiver.should_not == expected #any value
      #     Passes unless (receiver == expected)
      #
      #   receiver.should_not =~ expected #a regexp
      #     Passes unless (receiver =~ expected), where expected
      #     is a Regexp.
      def should_not(matcher=nil)
        NegativeExpectationHandler.new(self,matcher) if matcher
        should.not
      end

      # Specify that the receiver should have a
      # specified number of items in a named collection. For example:
      #
      #   team.should_have(40).players
      #
      # Passes if team.players.size == 40.
      #
      # Works for collections with size() and/or length() methods.
      def should_have(expected)
        should.have(expected)
      end
      alias_method :should_have_exactly, :should_have

      # Specify that the receiver should have at least a
      # specified number of items in a named collection. For example:
      #
      #   team.should_have_at_least(10).players
      #
      # Passes if team.players.size == 10 (or more)
      #
      # Fails if team.players.size == 9 (or less)
      #
      # Works for collections with size() and/or length() methods.
      def should_have_at_least(expected)
        should.have.at_least(expected)
      end

      # Specify that the receiver should have at most a
      # specified number of items in a named collection. For example:
      #
      #   team.should_have_at_most(10).players
      #
      # Passes if team.players.size == 10 (or less)
      #
      # Fails if team.players.size == 11 (or more)
      #
      # Works for collections with size() and/or length() methods.
      def should_have_at_most(expected)
        should.have.at_most(expected)
      end

      def should_be(expected = :___no_arg)
        should.be(expected)
      end
      
      def should_not_be(expected = :___no_arg)
        should.not.be(expected)
      end
      
      # Passes if &block returns true
      def should_satisfy(&block)
        should.satisfy(&block)
      end
      
      # Passes unless &block returns true
      def should_not_satisfy(&block)
        should.not.satisfy(&block)
      end
    end
  end
end

class Object
  include Spec::Expectations::ObjectExpectations
  include Spec::Expectations::UnderscoreSugar
end

Object.handle_underscores_for_rspec!
