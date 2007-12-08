module Spec
  module Example
    # TODO Make this class a tree structure and walk up the tree to get described_type etc.
    class ExampleGroupDescription #:nodoc:
      class << self
        def description_text(*args)
          args.inject("") do |result, arg|
            result << " " unless (result == "" || arg.to_s =~ /^(\s|\.|#)/)
            result << arg.to_s
          end
        end
      end

      attr_reader :example_group, :text, :described_type, :options
      alias_method :to_s, :text
      
      def initialize(example_group, *args)
        @example_group = example_group
        args, @options = args_and_options(*args)
        @described_type = assign_described_type(args)
        expand_spec_path
        @text = self.class.description_text(*args)
      end
      
      def text_parts
        [text]
      end

      def spec_path
        options[:spec_path]
      end
      
      def ==(value)
        case value
        when ExampleGroupDescription
          @text == value.text
        else
          @text == value
        end
      end
      
    private

      def assign_described_type(args) # :nodoc:
        args.reverse.each do |arg|
          case arg
          when ExampleGroupDescription
            return arg.described_type if arg.described_type
          when Module
            return arg
          end
        end
        return nil
      end
      
      def expand_spec_path
        if options.has_key?(:spec_path)
          options[:spec_path] = File.expand_path(options[:spec_path])
        end
      end
  
    end
  end
end
