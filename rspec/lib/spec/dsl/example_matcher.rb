module Spec
  module DSL
    class ExampleMatcher
      attr_accessor :example_description
      def initialize(behaviour_description)
        @behaviour_description = behaviour_description
        @example_description = nil
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
        Regexp.escape(@behaviour_description)
      end

      def behaviour_regexp_not_considering_modules
        Regexp.escape(@behaviour_description.split('::').last)
      end

      def example_regexp
        Regexp.escape(@example_description)
      end
    end
  end
end
