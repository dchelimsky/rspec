module Spec
  module Example
    class ExampleGroupProxy
      attr_reader :description, :nested_descriptions, :examples, :backtrace, :location
  
      def initialize(example_group)
        @description         = example_group.description
        @nested_descriptions = example_group.nested_descriptions
        @examples            = example_group.example_proxies
        @backtrace           = example_group.backtrace
        @location            = example_group.location
      end
      
      def filtered_description(filter)
        build_description_from(
          *nested_descriptions.collect do |description|
            description =~ filter ? $1 : description
          end
        )
      end
      
      def ==(other)
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

