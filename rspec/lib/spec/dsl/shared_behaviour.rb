module Spec
  module DSL
    class SharedBehaviour < Module
      class << self
        def add_shared_behaviour(behaviour)
          found_behaviour = find_shared_behaviour(behaviour.description)
          return if behaviour.equal?(found_behaviour)
          if(
            found_behaviour and
            File.expand_path(behaviour.description[:spec_path]) == File.expand_path(found_behaviour.description[:spec_path])
          )
            return
          end
          if found_behaviour
            raise ArgumentError.new("Shared Example '#{behaviour.description}' already exists")
          end
          shared_behaviours << behaviour
        end

        def find_shared_behaviour(behaviour_description)
          shared_behaviours.find { |b| b.description == behaviour_description }
        end

        def shared_behaviours
          # TODO - this needs to be global, or at least accessible from
          # from subclasses of Example in a centralized place. I'm not loving
          # this as a solution, but it works for now.
          $shared_behaviours ||= []
        end
      end
      include Behaviour
      public :include

      def initialize(*args, &behaviour_block)
        describe(*args, &behaviour_block)
      end

      def included(mod) # :nodoc:
        example_definitions.each { |e| mod.example_definitions << e; }
        before_each_parts.each   { |p| mod.before_each_parts << p }
        after_each_parts.each    { |p| mod.after_each_parts << p }
        before_all_parts.each    { |p| mod.before_all_parts << p }
        after_all_parts.each     { |p| mod.after_all_parts << p }
      end

      def register
        Spec::DSL::SharedBehaviour.add_shared_behaviour(self)
      end
    end
  end
end
