module Spec
  module Story
    class Step
      PARAM_PATTERN = /(\$\w*)/
      
      attr_reader :name
      def initialize(name, &block)
        @name = name
        assign_expression(name)
        init_module(name, &block)
      end

      def perform(instance, *args)
        instance.extend(@mod)
        instance.__send__(@name, *args)
      end

      def init_module(name, &block)
        @mod = Module.new do
          define_method(name.to_s, &block)
        end
      end

      def matches?(name)
        !(matches = name.match(@expression)).nil?
      end
            
      def parse_args(name)
        name.match(@expression)[1..-1]
      end

      private
      
        def assign_expression(name)
          expression = name.dup
          if String === expression
            expression.gsub! '(', '\('
            expression.gsub! ')', '\)'
            while expression =~ PARAM_PATTERN
              expression.gsub!($1, "(.*?)")
            end
          end
          @expression = Regexp.new("^#{expression}$")
        end

    end
  end
end