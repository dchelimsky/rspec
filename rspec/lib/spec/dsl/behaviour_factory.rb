module Spec
  module DSL
    class BehaviourFactory

      class << self
        BEHAVIOUR_CLASSES = {
          :default => Spec::DSL::Example,
          :shared => Spec::DSL::SharedBehaviour
        }
        
        # Registers a behaviour class +klass+ with the symbol
        # +behaviour_type+. For example:
        #
        #   Spec::DSL::BehaviourFactory.add_behaviour_class(:farm, Spec::Farm::DSL::FarmBehaviour)
        #
        # This will cause Kernel#describe from a file living in 
        # <tt>spec/farm</tt> to create behaviour instances of type
        # Spec::Farm::DSL::FarmBehaviour.
        def add_behaviour_class(behaviour_type, klass)
          BEHAVIOUR_CLASSES[behaviour_type] = klass
        end

        def remove_behaviour_class(behaviour_type)
          BEHAVIOUR_CLASSES.delete(behaviour_type)
        end

        def create(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            behaviour_type = :shared
            return create_shared_module(*args, &block)
          elsif opts[:behaviour_type]
            behaviour_type = opts[:behaviour_type]
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{BEHAVIOUR_CLASSES.keys.join('|')})/
            behaviour_type = $2.to_sym
          else
            behaviour_type = :default
          end
          behaviour_class = Class.new(BEHAVIOUR_CLASSES[behaviour_type])
          behaviour_class.describe(*args, &block)
        end

        protected
        def create_shared_module(*args, &block)
          BEHAVIOUR_CLASSES[:shared].new(*args, &block)
        end
      end
    end
  end
end
