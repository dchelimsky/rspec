module Spec
  module Runner
    class BehaviourRunner
      def initialize(options)
        @options = options
      end

      def load_files(files)
        # It's important that loading files (or choosing not to) stays the
        # responsibility of the BehaviourRunner. Some implementations (like)
        # the one using DRb may choose *not* to load files, but instead tell
        # someone else to do it over the wire.
        files.each do |file|
          load file
        end
      end

      def run
        prepare
        success = true
        example_groups.each do |behaviour|
          success = success & behaviour.suite.run
        end
        return success
      ensure
        finish
      end

      protected
      def prepare
        reporter.start(number_of_examples)
        example_groups.reverse! if reverse
        set_sequence_numbers
      end

      def finish
        reporter.end
        reporter.dump
      end

      def reporter
        @options.reporter
      end

      def reverse
        @options.reverse
      end

      # Sets the #number on each Example
      def set_sequence_numbers
        number = 0
        example_groups.each do |example_group|
          example_group.examples.each do |example|
            example.number = number
            number += 1
          end
        end
      end      

      def example_groups
        @options.example_groups
      end

      def number_of_examples
        @options.number_of_examples
      end
    end
  end
end