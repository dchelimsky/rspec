module Spec
  module DSL
    class ExampleFactory

      class << self
        EXAMPLE_CLASSES = {
          :default => Spec::DSL::Example,
          :shared => Spec::DSL::SharedBehaviour
        }
        
        # Registers a behaviour class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::DSL::ExampleFactory.add_example_class(:farm, Spec::Farm::DSL::FarmBehaviour)
        #
        # This will cause Kernel#describe from a file living in 
        # <tt>spec/farm</tt> to create behaviour instances of type
        # Spec::Farm::DSL::FarmBehaviour.
        def add_example_class(type, klass)
          EXAMPLE_CLASSES[type] = klass
        end
        
        def remove_example_class(type)
          EXAMPLE_CLASSES.delete(type)
        end

        def create(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            type = :shared
            return create_shared_module(*args, &block)
            
          # new: replaces behaviour_type  
          elsif opts[:type]
            type = opts[:type]
            
          #backwards compatibility
          elsif opts[:behaviour_type]
            type = opts[:behaviour_type]
            
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{EXAMPLE_CLASSES.keys.join('|')})/
            type = $2.to_sym
          else
            type = :default
          end
          example_class = Class.new(EXAMPLE_CLASSES[type])
          example_class.describe(*args, &block)
        end

        protected
        def create_shared_module(*args, &block)
          EXAMPLE_CLASSES[:shared].new(*args, &block)
        end
      end
    end
  end
end
