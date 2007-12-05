module Spec
  module Example
    class SharedExampleGroup < Module
      class << self
        def add_shared_example_group(new_example_group)
          guard_against_redefining_existing_example_group(new_example_group)
          shared_example_groups << new_example_group
        end

        def find_shared_example_group(example_group_description)
          shared_example_groups.find do |b|
            b.description == example_group_description
          end
        end

        def shared_example_groups
          # TODO - this needs to be global, or at least accessible from
          # from subclasses of Example in a centralized place. I'm not loving
          # this as a solution, but it works for now.
          $shared_example_groups ||= []
        end

        private
        def guard_against_redefining_existing_example_group(new_example_group)
          existing_example_group = find_shared_example_group(new_example_group.description)
          return unless existing_example_group
          return if new_example_group.equal?(existing_example_group)
          return if spec_path(new_example_group) == spec_path(existing_example_group)
          raise ArgumentError.new("Shared Example '#{existing_example_group.description}' already exists")
        end

        def spec_path(example_group)
          File.expand_path(example_group.description[:spec_path])
        end
      end
      include ExampleGroupMethods
      public :include

      def initialize(*args, &example_group_block)
        describe(*args)
        module_eval(&example_group_block)
        self.class.add_shared_example_group(self)
      end

      def included(mod) # :nodoc:
        before_each_parts.each   { |p| mod.before_each_parts << p }
        after_each_parts.each    { |p| mod.after_each_parts << p }
        before_all_parts.each    { |p| mod.before_all_parts << p }
        after_all_parts.each     { |p| mod.after_all_parts << p }
        example_objects.each do |example|
          mod.add_example example
        end
      end
    end
  end
end
