module Spec
  module Story
    class MatchingStep
      def initialize(expression, &block)
        raise "No block given to step: #{expression}" unless block_given?
        assign_name(expression)
        assign_expression(expression)
        init_module(expression, &block)
      end
      
      def matches?(name)
        !(matches = name.match(@expression)).nil?
      end
      
      def perform(instance, name, *ignore_args)
        instance.extend(@mod)
        instance.__send__(@name, *parse_args(name))
      end
      
      private
      
        def assign_name(expression)
          @name = expression.to_s
        end
      
        def assign_expression(expression)
          if String === expression
            while expression =~ /(\$\w*)/
              expression.gsub!($1, "(.*)")
            end
          end
          @expression = Regexp.new(expression)
        end
      
        def init_module(expression, &block)
          @mod = Module.new do
            define_method expression.to_s, &block
          end
        end
        
        def parse_args(name)
          name.match(@expression)[1..-1]
        end
    end
  end
end
