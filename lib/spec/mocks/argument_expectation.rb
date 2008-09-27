module Spec
  module Mocks
    
    class ArgumentExpectation
      attr_reader :args
      @@constraint_classes = Hash.new
      @@constraint_classes[:anything] = ArgumentConstraints::AnyArgConstraint
      @@constraint_classes[:boolean] = ArgumentConstraints::BooleanArgConstraint
      @@constraint_classes[:numeric] = ArgumentConstraints::Deprecated::NumericArgConstraint
      @@constraint_classes[:string] = ArgumentConstraints::Deprecated::StringArgConstraint
      
      def initialize(args, &block)
        @args = args
        @constraints_block = block
        
        if [:any_args] == args
          @expected_args = nil
          warn_constraint_symbol_deprecated(:any_args.inspect, "any_args()")
        elsif ArgumentConstraints::AnyArgsConstraint === args.first
          @expected_args = nil
        elsif [:no_args] == args
          @expected_args = []
          warn_constraint_symbol_deprecated(:no_args.inspect, "no_args()")
        elsif ArgumentConstraints::NoArgsConstraint === args.first
          @expected_args = []
        else
          @expected_args = args.collect {|arg| constraint_for(arg)}
        end
      end
      
      def warn_constraint_symbol_deprecated(deprecated_method, instead)
        Kernel.warn "The #{deprecated_method} constraint is deprecated. Use #{instead} instead."
      end
      
      def constraint_for(arg)
        if [:anything, :numeric, :boolean, :string].include?(arg)
          case arg
          when :anything
            instead = "anything()"
          when :boolean
            instead = "boolean()"
          when :numeric
            instead = "an_instance_of(Numeric)"
          when :string
            instead = "an_instance_of(String)"
          end
          warn_constraint_symbol_deprecated(arg.inspect, instead)
          return @@constraint_classes[arg].new(arg)
        end
        return ArgumentConstraints::MatcherConstraint.new(arg) if is_matcher?(arg)
        return ArgumentConstraints::RegexpArgConstraint.new(arg) if arg.is_a?(Regexp)
        return ArgumentConstraints::EqualityProxy.new(arg)
      end
      
      def is_matcher?(obj)
        return obj.respond_to?(:matches?) && obj.respond_to?(:description)
      end
      
      def args_match?(given_args)
        if @constraints_block
          @constraints_block.call(*given_args)
          return true
        end
        
        @expected_args.nil? || @expected_args == given_args
      end
      
    end
    
  end
end
