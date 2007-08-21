module Spec
  module DSL
    class ExampleMatcher
      attr_writer :example_description
      def initialize(behaviour_description, example_description=nil)
        @behaviour_description = behaviour_description
        @example_description = example_description
      end
      
      def matches?(specified_examples)
        specified_examples.each do |specified_example|
          return true if matches_literal_example?(specified_example) || matches_example_not_considering_modules?(specified_example)
        end
        false
      end
      
      private
      def matches_literal_example?(specified_example)
        specified_example =~ /(^#{context_regexp} #{example_regexp}$|^#{context_regexp}$|^#{example_regexp}$)/
      end

      def matches_example_not_considering_modules?(specified_example)
        specified_example =~ /(^#{context_regexp_not_considering_modules} #{example_regexp}$|^#{context_regexp_not_considering_modules}$|^#{example_regexp}$)/
      end

      def context_regexp
        Regexp.escape(@behaviour_description)
      end

      def context_regexp_not_considering_modules
        Regexp.escape(@behaviour_description.split('::').last)
      end

      def example_regexp
        Regexp.escape(@example_description)
      end
    end
  end
end
