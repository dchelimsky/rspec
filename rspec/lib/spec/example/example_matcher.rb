module Spec
  module DSL
    class ExampleMatcher
      def initialize(example_group_name, example_name)
        @example_group_name = example_group_name
        @example_name = example_name
      end
      
      def matches?(specified_examples)
        specified_examples.each do |specified_example|
          return true if matches_literal_example?(specified_example) || matches_example_not_considering_modules?(specified_example)
        end
        false
      end
      
      protected
      def matches_literal_example?(specified_example)
        specified_example =~ /(^#{behaviour_regexp} #{example_regexp}$|^#{behaviour_regexp}$|^#{example_regexp}$)/
      end

      def matches_example_not_considering_modules?(specified_example)
        specified_example =~ /(^#{behaviour_regexp_not_considering_modules} #{example_regexp}$|^#{behaviour_regexp_not_considering_modules}$|^#{example_regexp}$)/
      end

      def behaviour_regexp
        Regexp.escape(@example_group_name)
      end

      def behaviour_regexp_not_considering_modules
        Regexp.escape(@example_group_name.split('::').last)
      end

      def example_regexp
        Regexp.escape(@example_name)
      end
    end
  end
end
