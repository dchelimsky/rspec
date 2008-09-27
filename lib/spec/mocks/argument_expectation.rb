module Spec
  module Mocks
  
    class MatcherConstraint
      def initialize(matcher)
        @matcher = matcher
      end
      
      def ==(value)
        @matcher.matches?(value)
      end
    end
      
    class EqualityConstraint
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
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end
    
    class StringArgConstraint
      def initialize(ignore)
      end
      
      def ==(value)
        value.is_a?(String)
      end
    end
    
    class DuckTypeArgConstraint
      def initialize(*methods_to_respond_to)
        @methods_to_respond_to = methods_to_respond_to
      end
  
      def ==(value)
        @methods_to_respond_to.all? { |sym| value.respond_to?(sym) }
      end
      
      def description
        "duck_type"
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
    

    class ArgumentExpectation
      attr_reader :args
      @@constraint_classes = Hash.new { |hash, key| EqualityConstraint}
      @@constraint_classes[:anything] = AnyArgConstraint
      @@constraint_classes[:numeric] = NumericArgConstraint
      @@constraint_classes[:boolean] = BooleanArgConstraint
      @@constraint_classes[:string] = StringArgConstraint
      
      def initialize(args, &block)
        @args = args
        @constraints_block = block
        
        if [:any_args] == args
          @expected_params = nil
          warn_constraint_symbol_deprecated(:any_args.inspect, "any_args()")
        elsif args.length == 1 && args[0].is_a?(AnyArgsConstraint) then @expected_params = nil
        elsif [:no_args] == args
          @expected_params = []
          warn_constraint_symbol_deprecated(:no_args.inspect, "no_args()")
        elsif args.length == 1 && args[0].is_a?(NoArgsConstraint) then @expected_params = []
        else @expected_params = process_arg_constraints(args)
        end
      end
      
      def process_arg_constraints(constraints)
        constraints.collect do |constraint| 
          convert_constraint(constraint)
        end
      end
      
      def warn_constraint_symbol_deprecated(deprecated_method, instead)
        Kernel.warn "The #{deprecated_method} constraint is deprecated. Use #{instead} instead."
      end
      
      def convert_constraint(constraint)
        if [:anything, :numeric, :boolean, :string].include?(constraint)
          case constraint
          when :anything
            instead = "anything()"
          when :boolean
            instead = "boolean()"
          when :numeric
            instead = "an_instance_of(Numeric)"
          when :string
            instead = "an_instance_of(String)"
          end
          warn_constraint_symbol_deprecated(constraint.inspect, instead)
          return @@constraint_classes[constraint].new(constraint)
        end
        return MatcherConstraint.new(constraint) if is_matcher?(constraint)
        return RegexpArgConstraint.new(constraint) if constraint.is_a?(Regexp)
        return EqualityConstraint.new(constraint)
      end
      
      def is_matcher?(obj)
        return obj.respond_to?(:matches?) && obj.respond_to?(:description)
      end
      
      def check_args(args)
        if @constraints_block
          @constraints_block.call(*args)
          return true
        end
        
        @expected_params.nil? || @expected_params == args
      end
      
    end
    
  end
end
