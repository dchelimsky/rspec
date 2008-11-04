module Spec
  module Example
    class SharedExampleGroup < Module
      module ClassMethods
        def add_shared_example_group(new_example_group)
          unless already_registered?(new_example_group)
            shared_example_groups << new_example_group
          end
          new_example_group
        end

        def find_shared_example_group(example_group_description)
          shared_example_groups.find {|b| b.description == example_group_description}
        end

        def register(*args, &block)
          add_shared_example_group new(*args, &block)
        end
        
        def clear_shared_example_groups
          shared_example_groups.clear
        end
        
        def include?(group)
          shared_example_groups.include?(group)
        end
        
        def count
          shared_example_groups.length
        end

      private
      
        def shared_example_groups
          @shared_example_groups ||= []
        end
      
        def already_registered?(new_example_group)
          existing_example_group = find_shared_example_group(new_example_group.description)
          return false unless existing_example_group
          return true if new_example_group.equal?(existing_example_group)
          return true if spec_path(new_example_group) == spec_path(existing_example_group)
          raise ArgumentError.new("Shared Example '#{existing_example_group.description}' already exists")
        end

        def spec_path(example_group)
          File.expand_path(example_group.spec_path)
        end
      end

      extend ClassMethods
      include ExampleGroupMethods

      def initialize(*args, &example_group_block)
        describe(*args)
        @example_group_block = example_group_block
      end

      def included(mod) # :nodoc:
        mod.module_eval(&@example_group_block)
      end

      def each_ancestor_example_group_class(superclass_last=false)
        yield self
      end
    end
  end
end
