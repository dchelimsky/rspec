module Spec
  module DSL
    class ExampleGroupFactory
      class << self
        def reset!
          @example_group_types = {
            :default => Spec::DSL::ExampleGroup,
            :shared => Spec::DSL::SharedExampleGroup
          }
        end

        # Registers a behaviour class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::DSL::ExampleGroupFactory.register(:farm, Spec::Farm::DSL::FarmBehaviour)
        #
        # This will cause Main#describe from a file living in 
        # <tt>spec/farm</tt> to create behaviour instances of type
        # Spec::Farm::DSL::FarmBehaviour.
        def register(id, behaviour)
          @example_group_types[id] = behaviour
        end

        def get(id=:default)
          id ||= :default
          if @example_group_types.values.include?(id)
            return id
          else
            behaviour = @example_group_types[id]
            return behaviour
          end
        end
        
        def get!(id=:default)
          behaviour = get(id)
          unless behaviour
            raise "ExampleGroup #{id.inspect} is not registered. Use ::Spec::DSL::ExampleGroupFactory.register"
          end
          return behaviour
        end  

        # Dynamically creates a class 
        def create_behaviour(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            id = :shared
            return create_shared_module(*args, &block)
            
          # new: replaces behaviour_type  
          elsif opts[:type]
            id = opts[:type]
            
          #backwards compatibility
          elsif opts[:behaviour_type]
            id = opts[:behaviour_type]
            
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{@example_group_types.keys.join('|')})/
            id = $2.to_sym
          else
            id = :default
          end
          superclass = get(id)
          behaviour = create_uniquely_named_class(superclass)
          behaviour.describe(*args, &block)
          behaviour
        end

        protected
        
        def create_uniquely_named_class(superclass)
          behaviour = Class.new(superclass)
          @class_count ||= 0
          class_name = "Subclass_#{@class_count}"
          @class_count += 1
          superclass.instance_eval do
            const_set(class_name, behaviour)
          end
        end
        
        def create_shared_module(*args, &block)
          @example_group_types[:shared].new(*args, &block)
        end
      end
      self.reset!
    end
  end
end
