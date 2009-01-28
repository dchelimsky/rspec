module Spec
  module Example
    
    class ExampleGroupFactory
      module ClassMethods
        def reset
          @example_group_types = nil
          default(ExampleGroup)
        end

        def example_group_creation_listeners
          @example_group_creation_listeners ||= []
        end

        def register_example_group(klass)
          example_group_creation_listeners.each do |listener|
            listener.register_example_group(klass)
          end
        end

        def create_shared_example_group(*args, &example_group_block) # :nodoc:
          ::Spec::Example::add_spec_path_to(args)
          ::Spec::Example::SharedExampleGroup.register(*args, &example_group_block)
        end

        # Creates a new subclass of self, with a name "under" our own name.
        # Example:
        #
        #   x = Foo::Bar.subclass('Zap'){}
        #   x.name # => Foo::Bar::Zap_1
        #   x.superclass.name # => Foo::Bar
        def create_example_group_subclass(base, *args, &example_group_block) # :nodoc:
          @class_count ||= 0
          @class_count += 1
          # FIXME - Subclass_1 should be Zap_1 (based on args)
          klass = base.const_set("Subclass_#{@class_count}", Class.new(base))
          klass.set_description(*args)
          example_group_block = include_constants_in(args.last[:scope], &example_group_block)
          klass.module_eval(&example_group_block)
          klass
        end

        # Registers an example group class +klass+ with the symbol +type+. For
        # example:
        #
        #   Spec::Example::ExampleGroupFactory.register(:farm, FarmExampleGroup)
        #
        # With that you can append a hash with :type => :farm to the describe
        # method and it will load an instance of FarmExampleGroup.
        #
        #   describe Pig, :type => :farm do
        #     ...
        #
        # If you don't use the hash explicitly, <tt>describe</tt> will
        # implicitly use an instance of FarmExampleGroup for any file loaded
        # from the <tt>./spec/farm</tt> directory.
        def register(key, example_group_class)
          @example_group_types[key.to_sym] = example_group_class
        end

        # Sets the default ExampleGroup class
        def default(example_group_class)
          Spec.__send__ :remove_const, :ExampleGroup if Spec.const_defined?(:ExampleGroup)
          Spec.const_set(:ExampleGroup, example_group_class)
          old = @example_group_types
          @example_group_types = Hash.new(example_group_class)
          @example_group_types.merge!(old) if old
        end

        def [](key)
          if @example_group_types.values.include?(key)
            key
          else
            @example_group_types[key]
          end
        end

        def create_example_group(*args, &block)
          raise ArgumentError if args.empty?
          raise ArgumentError unless block
          Spec::Example::add_spec_path_to(args)
          superclass = determine_superclass(args.last)
          superclass.describe(*args, &block)
        end

        def include_constants_in(context, &block)
          if (Spec::Ruby.version.to_f >= 1.9) & (Module === context) & !(Class === context)
            return lambda {include context;instance_eval(&block)}
          end
          block
        end

        def assign_scope(scope, args)
          args.last[:scope] = scope
        end

      protected

        def determine_superclass(opts)
          key = if opts[:type]
            opts[:type]
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{@example_group_types.keys.sort_by{|k| k.to_s.length}.reverse.join('|')})/
            $2 == '' ? nil : $2.to_sym
          end
          self[key]
        end

      end
      extend ClassMethods
      self.reset
    end
  end
end
