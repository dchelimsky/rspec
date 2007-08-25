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
            raise ArgumentError.new("Shared Behaviour '#{behaviour.description}' already exists")
          end
          shared_behaviours << behaviour
        end

        def find_shared_behaviour(behaviour_description)
          shared_behaviours.find { |b| b.description == behaviour_description }
        end

        def shared_behaviours
          # TODO - this needs to be global, or at least accessible from
          # from subclasses of Behaviour in a centralized place. I'm not loving
          # this as a solution, but it works for now.
          $shared_behaviours ||= []
        end
      end
      include BehaviourApi
      public :include

      def shared?
        true
      end
    end
  end
end
