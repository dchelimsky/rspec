module Spec
  module Mocks
    
    class ArgumentExpectation
      attr_reader :args
      
      def initialize(args, &block)
        @args = args
        @constraints_block = block
        
        if ArgumentConstraints::AnyArgsConstraint === args.first
          @expected_args = nil
        elsif ArgumentConstraints::NoArgsConstraint === args.first
          @expected_args = []
        else
          @expected_args = args.collect {|arg| constraint_for(arg)}
        end
      end
      
      def constraint_for(arg)
        return ArgumentConstraints::MatcherConstraint.new(arg)   if is_matcher?(arg)
        return ArgumentConstraints::RegexpConstraint.new(arg) if arg.is_a?(Regexp)
        return ArgumentConstraints::EqualityProxy.new(arg)
      end
      
      def is_matcher?(obj)
        return obj.respond_to?(:matches?) && obj.respond_to?(:description)
      end
      
      def args_match?(given_args)
        return @constraints_block.call(*given_args) if @constraints_block
        @expected_args.nil? || @expected_args == given_args
      end
      
    end
    
  end
end
