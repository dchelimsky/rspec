module Spec
  module Example
    # Lightweight representation of an example group. This is the object
    # that is passed to Spec::Runner::Formatter::BaseFormatter#add_example_group
    class ExampleGroupProxy
      
      def initialize(example_group) # :nodoc:
        @description         = example_group.description
        @nested_descriptions = example_group.nested_descriptions
        @examples            = example_group.example_proxies
        @location            = example_group.location
        @backtrace           = example_group.backtrace
      end
      
      # This is the docstring passed to the <tt>describe()</tt> method or any
      # of its aliases
      attr_reader :description
      
      # Used by Spec::Runner::Formatter::NestedTextFormatter to access the
      # docstrings for each example group in a nested group.
      attr_reader :nested_descriptions
      
      # A collection of ExampleGroupProxy instances, one for each example
      # declared in this group.
      attr_reader :examples
      
      # The file and line number at which the represented example group
      # was declared. This is extracted from <tt>caller</tt>, and is therefore
      # formatted as an individual line in a backtrace.
      attr_reader :location
      
      # Deprecated - use location() instead
      def backtrace
        @backtrace
      end
  
      # Returns the nested_descriptions collection with any descriptions
      # matching the submitted regexp removed.
      def filtered_description(regexp)
        build_description_from(
          *nested_descriptions.collect do |description|
            description =~ regexp ? $1 : description
          end
        )
      end
      
      def ==(other) # :nodoc:
        other.description == description
      end
      
    private
    
      # FIXME - this is duplicated from ExampleGroupMethods
      def build_description_from(*args)
        text = args.inject("") do |description, arg|
          description << " " unless (description == "" || arg.to_s =~ /^(\s|\.|#)/)
          description << arg.to_s
        end
        text == "" ? nil : text
      end
    end
  end
end

