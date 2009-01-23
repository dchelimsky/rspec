module Spec
  module Example
    class ExampleGroupDescription
      attr_reader :description, :nested_descriptions, :nested_description
      
      def initialize(example_group_hierarchy)
        example_group = example_group_hierarchy.last
        @description ||= ExampleGroupMethods.description_text(*example_group.description_parts) || example_group.to_s
        @nested_descriptions = example_group_hierarchy.nested_descriptions
        @nested_description = @nested_descriptions.last
      end
      
      
      
      def filtered_description(filter)
        ExampleGroupMethods.description_text(
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