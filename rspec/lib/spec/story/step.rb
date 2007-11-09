module Spec
  module Story
    class Step
      attr_reader :name
      def initialize(name, &block)
        @name = name
        assign_expression(name)
        init_module(name, &block)
      end

      def perform(instance, name, *args)
        instance.extend(@mod)
        if args.empty?
          instance.__send__(@name, *parse_args(name))
        else
          instance.__send__(@name, *args)
        end
      end

      def init_module(expression, &block)
        @mod = Module.new do
          define_method expression.to_s, &block
        end
      end

      def matches?(name)
        !(matches = name.match(@expression)).nil?
      end
            
      private
      
        def parse_args(name)
          name.match(@expression)[1..-1]
        end

        def assign_expression(name)
          expression = name.dup
          if String === expression
            while expression =~ /(\$\w*)/
              expression.gsub!($1, "(.*)")
            end
          end
          @expression = Regexp.new("^#{expression}$")
        end

    end
  end
end