module Spec
  module Example
    class ExampleGroupDescription
      def self.build_description_from(*args)
        text = args.inject("") do |description, arg|
          description << " " unless (description == "" || arg.to_s =~ /^(\s|\.|#)/)
          description << arg.to_s
        end
        text == "" ? nil : text
      end
      
      attr_reader :description, :nested_descriptions
      
      def initialize(example_group_hierarchy)
        example_group = example_group_hierarchy.last
        @description = ExampleGroupDescription.build_description_from(*example_group.description_parts) || example_group.to_s
        @nested_descriptions = example_group_hierarchy.nested_descriptions
      end
      
      def nested_description
        @nested_descriptions.last
      end
      
      def filtered_description(filter)
        ExampleGroupDescription.build_description_from(
          *nested_descriptions.collect do |description|
            description =~ filter ? $1 : description
          end
        )
      end
      
      def ==(other)
        nested_descriptions == other.nested_descriptions
      end
    end
  end
end