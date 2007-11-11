module Spec
  module DSL
    class SharedExampleGroup < Module
      class << self
        def add_shared_example_group(example_group)
          found_example_group = find_shared_example_group(example_group.description)
          return if example_group.equal?(found_example_group)
          if(
            found_example_group and
            File.expand_path(example_group.description[:spec_path]) == File.expand_path(found_example_group.description[:spec_path])
          )
            return
          end
          if found_example_group
            raise ArgumentError.new("Shared Example '#{example_group.description}' already exists")
          end
          shared_example_groups << example_group
        end

        def find_shared_example_group(example_group_description)
          shared_example_groups.find { |b| b.description == example_group_description }
        end

        def shared_example_groups
          # TODO - this needs to be global, or at least accessible from
          # from subclasses of Example in a centralized place. I'm not loving
          # this as a solution, but it works for now.
          $shared_example_groups ||= []
        end
      end
      include ExampleGroupMethods
      public :include

      def initialize(*args, &example_group_block)
        describe(*args, &example_group_block)
      end

      def included(mod) # :nodoc:
        examples.each { |e| mod.examples << e; }
        before_each_parts.each   { |p| mod.before_each_parts << p }
        after_each_parts.each    { |p| mod.after_each_parts << p }
        before_all_parts.each    { |p| mod.before_all_parts << p }
        after_all_parts.each     { |p| mod.after_all_parts << p }
      end

      def register
        Spec::DSL::SharedExampleGroup.add_shared_example_group(self)
      end
    end
  end
end
