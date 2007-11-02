module Spec
  module DSL
    # See http://rspec.rubyforge.org/documentation/before_and_after.html
    module Behaviour
      attr_accessor :description

      def describe(*args, &behaviour_block)
        set_description(*args)
        before_eval
        module_eval(&behaviour_block) if behaviour_block
        self
      end

      # Use this to pull in examples from shared behaviours.
      # See Spec::Runner for information about shared behaviours.
      def it_should_behave_like(shared_behaviour)
        case shared_behaviour
        when SharedBehaviour
          include shared_behaviour
        else
          behaviour = SharedBehaviour.find_shared_behaviour(shared_behaviour)
          unless behaviour
            raise RuntimeError.new("Shared Example '#{shared_behaviour}' can not be found")
          end
          include(behaviour)
        end
      end

      # :call-seq:
      #   predicate_matchers[matcher_name] = method_on_object
      #   predicate_matchers[matcher_name] = [method1_on_object, method2_on_object]
      #
      # Dynamically generates a custom matcher that will match
      # a predicate on your class. RSpec provides a couple of these
      # out of the box:
      #
      #   exist (or state expectations)
      #     File.should exist("path/to/file")
      #
      #   an_instance_of (for mock argument constraints)
      #     mock.should_receive(:message).with(an_instance_of(String))
      #
      # == Examples
      #
      #   class Fish
      #     def can_swim?
      #       true
      #     end
      #   end
      #
      #   describe Fish do
      #     predicate_matchers[:swim] = :can_swim?
      #     it "should swim" do
      #       Fish.new.should swim
      #     end
      #   end
      def predicate_matchers
        @predicate_matchers ||= {:exist => :exist?, :an_instance_of => :is_a?}
      end

      # Creates an instance of Spec::DSL::ExampleDefinition and adds
      # it to a collection of example_definitions of the current behaviour.
      def it(description=:__generate_description, opts={}, &block)
        example_definitions << create_example_definition(description, opts, &block)
      end
      
      alias_method :specify, :it
      
      # Use this to temporarily disable an example.
      def xit(description=:__generate_description, opts={}, &block)
        Kernel.warn("Example disabled: #{description}")
      end

      def described_type
        description.described_type
      end

      def example_definitions
        @example_definitions ||= []
      end

      def number_of_examples
        example_definitions.length
      end

      def create_example_definition(description, options={}, &block)
        ExampleDefinition.new(description, options, &block)
      end

      def prepend_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts.unshift(block)
      end
      def append_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts << block
      end
      alias_method :before, :append_before

      def prepend_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts.unshift(block)
      end
      alias_method :after, :prepend_after
      def append_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts << block
      end

      def scope_and_options(*args)
        args, options = args_and_options(*args)
        scope = (args[0] || :each), options
      end

      def remove_after(scope, &block)
        after_each_parts.delete(block)
      end

      # Deprecated. Use before(:each)
      def setup(&block)
        before(:each, &block)
      end

      # Deprecated. Use after(:each)
      def teardown(&block)
        after(:each, &block)
      end

      def before_all_parts # :nodoc:
        @before_all_parts ||= []
      end

      def after_all_parts # :nodoc:
        @after_all_parts ||= []
      end

      def before_each_parts # :nodoc:
        @before_each_parts ||= []
      end

      def after_each_parts # :nodoc:
        @after_each_parts ||= []
      end

      def clear_before_and_after! # :nodoc:
        @before_all_parts = nil
        @after_all_parts = nil
        @before_each_parts = nil
        @after_each_parts = nil
      end
      
      protected

      def before_parts_from_scope(scope)
        case scope
        when :each; before_each_parts
        when :all; before_all_parts
        end
      end

      def after_parts_from_scope(scope)
        case scope
        when :each; after_each_parts
        when :all; after_all_parts
        end
      end      

      def before_eval
      end

      def set_description(*args)
        unless self.class == Example
          args << {} unless Hash === args.last
          args.last[:behaviour_class] = self
        end
        self.description = BehaviourDescription.new(*args)
        if described_type.class == Module
          include described_type
        end
        self.description
      end
    end
  end
end