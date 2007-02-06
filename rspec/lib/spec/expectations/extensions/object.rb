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
      def should(matcher=nil, &block)
        ExpectationMatcherHandler.new(self, matcher, &block) if matcher
        Should::Should.new(self)
      end

      # Supports the following expectations:
      #   receiver.should_not == expected #any value
      #     Passes unless (receiver == expected)
      #
      #   receiver.should_not =~ expected #a regexp
      #     Passes unless (receiver =~ expected), where expected
      #     is a Regexp.
      def should_not(matcher=nil, &block)
        NegativeExpectationMatcherHandler.new(self, matcher, &block) if matcher
        should.not
      end

      # Deprecated: use should have(n).items (see Spec::Expectations::Matchers)
      # This will be removed in 0.9
      def should_have(expected)
        should.have(expected)
      end
      alias_method :should_have_exactly, :should_have

      # Deprecated: use should have_at_least(n).items (see Spec::Expectations::Matchers)
      # This will be removed in 0.9
      def should_have_at_least(expected)
        should.have.at_least(expected)
      end

      # Deprecated: use should have_at_most(n).items (see Spec::Expectations::Matchers)
      # This will be removed in 0.9
      def should_have_at_most(expected)
        should.have.at_most(expected)
      end

      # Deprecated: use should be(expected) (see Spec::Expectations::Matchers)
      # This will be removed in 0.9
      def should_be(expected = :___no_arg)
        should.be(expected)
      end
      
      # Deprecated: use should_not be(expected) (see Spec::Expectations::Matchers)
      # This will be removed in 0.9
      def should_not_be(expected = :___no_arg)
        should.not.be(expected)
      end
    end
  end
end

class Object
  include Spec::Expectations::ObjectExpectations
  include Spec::Expectations::UnderscoreSugar
end

Object.handle_underscores_for_rspec!
