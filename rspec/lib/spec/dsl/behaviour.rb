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

      # Use this to pull in example_definitions from shared behaviours.
      # See Spec::Runner for information about shared behaviours.
      def it_should_behave_like(behaviour_description)
        behaviour = SharedBehaviour.find_shared_behaviour(behaviour_description)
        unless behaviour
          raise RuntimeError.new("Shared Example '#{behaviour_description}' can not be found")
        end
        include(behaviour)
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

      def behaviour_type #:nodoc:
        description[:behaviour_type]
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
        add(scope, options, :before, :unshift, &block)
      end
      def append_before(*args, &block)
        scope, options = scope_and_options(*args)
        add(scope, options, :before, :<<, &block)
      end
      alias_method :before, :append_before

      def prepend_after(*args, &block)
        scope, options = scope_and_options(*args)
        add(scope, options, :after, :unshift, &block)
      end
      alias_method :after, :prepend_after
      def append_after(*args, &block)
        scope, options = scope_and_options(*args)
        add(scope, options, :after, :<<, &block)
      end

      def scope_and_options(*args)
        args, options = args_and_options(*args)
        scope = (args[0] || :each), options
      end

      def add(scope, options, where, how, &block)
        scope ||= :each
        options ||= {}
        behaviour_type = options[:behaviour_type]
        case scope
          when :each; self.__send__("#{where}_each_parts", behaviour_type).__send__(how, block)
          when :all;  self.__send__("#{where}_all_parts", behaviour_type).__send__(how, block)
        end
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

      def before_all_parts(behaviour_type=nil) # :nodoc:
        @before_all_parts ||= {}
        @before_all_parts[behaviour_type] ||= []
      end

      def after_all_parts(behaviour_type=nil) # :nodoc:
        @after_all_parts ||= {}
        @after_all_parts[behaviour_type] ||= []
      end

      def before_each_parts(behaviour_type=nil) # :nodoc:
        @before_each_parts ||= {}
        @before_each_parts[behaviour_type] ||= []
      end

      def after_each_parts(behaviour_type=nil) # :nodoc:
        @after_each_parts ||= {}
        @after_each_parts[behaviour_type] ||= []
      end

      def clear_before_and_after! # :nodoc:
        @before_all_parts = nil
        @after_all_parts = nil
        @before_each_parts = nil
        @after_each_parts = nil
      end
      
      protected

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