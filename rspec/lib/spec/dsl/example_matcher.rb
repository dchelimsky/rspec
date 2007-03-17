module Spec
  module DSL
    class ExampleMatcher

      attr_writer :example_desc
      def initialize(context_desc, example_desc=nil)
        @context_desc = context_desc
        @example_desc = example_desc
      end
      
      def matches?(desc)
        desc =~ /(^#{context_regexp} #{example_regexp}$|^#{context_regexp}$|^#{example_regexp}$)/
      end
      
      private
        def context_regexp
          Regexp.escape(@context_desc)
        end
        
        def example_regexp
          Regexp.escape(@example_desc)
        end
    end
  end
end
