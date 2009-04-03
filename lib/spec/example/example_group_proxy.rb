module Spec
  module Example
    # Lightweight proxy for an example group. This is the object that is passed
    # to Spec::Runner::Formatter::BaseFormatter#example_group_started
    class ExampleGroupProxy
      
      def initialize(example_group) # :nodoc:
        @description         = example_group.description
        @nested_descriptions = example_group.nested_descriptions
        @examples            = example_group.example_proxies
        @location            = example_group.location
        @backtrace           = example_group.backtrace # deprecated - see the backtrace method below
      end
      
      # This is the description passed to the <tt>describe()</tt> method or any
      # of its aliases
      attr_reader :description
      
      # Used by Spec::Runner::Formatter::NestedTextFormatter to access the
      # description of each example group in a nested group separately.
      attr_reader :nested_descriptions
      
      # A collection of ExampleGroupProxy objects, one for each example
      # declared in this group.
      attr_reader :examples
      
      # The file and line number at which the proxied example group
      # was declared. This is extracted from <tt>caller</tt>, and is therefore
      # formatted as an individual line in a backtrace.
      attr_reader :location
      
      # Deprecated - use location() instead
      def backtrace
        Spec::deprecate("ExampleGroupProxy#backtrace","ExampleGroupProxy#location")
        @backtrace
      end
  
      # Deprecated - just use gsub on the description instead.
      def filtered_description(regexp)
        Spec::deprecate("ExampleGroupProxy#filtered_description","gsub (or similar) to modify ExampleGroupProxy#description")
        build_description_from(
          *nested_descriptions.collect do |description|
            description =~ regexp ? description.gsub($1, "") : description
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

