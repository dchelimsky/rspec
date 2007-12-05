module Spec
  module Example
    class ExampleGroupFactory
      class << self
        def reset
          @example_group_types = {
            :default => Spec::Example::ExampleGroup,
            :shared => Spec::Example::SharedExampleGroup
          }
        end

        # Registers an example group class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::Example::ExampleGroupFactory.register(:farm, Spec::Farm::Example::FarmExampleGroup)
        #
        # This will cause Main#describe from a file living in 
        # <tt>spec/farm</tt> to create example group instances of type
        # Spec::Farm::Example::FarmExampleGroup.
        def register(id, behaviour)
          @example_group_types[id] = behaviour
        end

        def get(id=:default)
          id ||= :default
          if @example_group_types.values.include?(id)
            return id
          else
            return @example_group_types[id]
          end
        end
        
        def get!(id=:default)
          example_group_class = get(id)
          unless example_group_class
            raise "ExampleGroup #{id.inspect} is not registered. Use ::Spec::Example::ExampleGroupFactory.register"
          end
          return example_group_class
        end  

        def create_example_group(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            @example_group_types[:shared].new(*args, &block)
          else
            superclass = determine_superclass(opts)
            superclass.describe(*args, &block)
          end
        end

        protected

        def determine_superclass(opts)
          if opts[:type]
            id = opts[:type]
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{@example_group_types.keys.join('|')})/
            id = $2.to_sym
          else
            id = :default
          end
          get(id)
        end

      end
      self.reset
    end
  end
end
