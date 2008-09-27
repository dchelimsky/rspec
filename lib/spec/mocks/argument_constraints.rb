module Spec
  module Mocks

    module ArgumentConstraints

      class MatcherConstraint
        def initialize(matcher)
          @matcher = matcher
        end

        def ==(value)
          @matcher.matches?(value)
        end
      end

      class EqualityProxy
        def initialize(given)
          @given = given
        end

        def ==(expected)
          @given == expected
        end
      end

      class RegexpArgConstraint
        def initialize(regexp)
          @regexp = regexp
        end

        def ==(value)
          return value =~ @regexp unless value.is_a?(Regexp)
          value == @regexp
        end
      end

      class AnyArgConstraint
        def initialize(ignore)
        end

        def ==(other)
          true
        end
      end

      class AnyArgsConstraint
        def description
          "any args"
        end
      end

      class NoArgsConstraint
        def description
          "no args"
        end

        def ==(args)
          args == []
        end
      end

      class NumericArgConstraint
        def initialize(ignore)
        end

        def ==(value)
          value.is_a?(Numeric)
        end
      end

      class BooleanArgConstraint
        def initialize(ignore)
        end

        def ==(value)
          TrueClass === value || FalseClass === value
        end
      end

      class StringArgConstraint
        def initialize(ignore)
        end

        def ==(value)
          String === value
        end
      end

      class DuckTypeArgConstraint
        def initialize(*methods_to_respond_to)
          @methods_to_respond_to = methods_to_respond_to
        end

        def ==(value)
          @methods_to_respond_to.all? { |sym| value.respond_to?(sym) }
        end
      end

      class HashIncludingConstraint
        def initialize(expected)
          @expected = expected
        end

        def ==(actual)
          @expected.each do | key, value |
            # check key for case that value evaluates to nil
            return false unless actual.has_key?(key) && actual[key] == value
          end
          true
        rescue NoMethodError => ex
          return false
        end

        def description
          "hash_including(#{@expected.inspect.sub(/^\{/,"").sub(/\}$/,"")})"
        end

      end      

      def duck_type(*args)
        DuckTypeArgConstraint.new(*args)
      end

      def any_args
        AnyArgsConstraint.new
      end
      
      def anything
        AnyArgConstraint.new(nil)
      end
      
      def boolean
        BooleanArgConstraint.new(nil)
      end
      
      def hash_including(expected={})
        HashIncludingConstraint.new(expected)
      end
      
      def no_args
        NoArgsConstraint.new
      end
    end
  end
end
