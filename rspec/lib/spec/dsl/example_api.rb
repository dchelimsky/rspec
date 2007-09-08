module Spec
  module DSL
    module ExampleApi
      include ExampleCallbacks
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
      def xit(description=:__generate_description, opts={}, &block)
        warn("Example #{description} is disabled")
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

      def matches?(specified_examples)
        matcher ||= ExampleMatcher.new(description.to_s)

        example_definitions.each do |example|
          return true if example.matches?(matcher, specified_examples)
        end
        return false
      end

      def create_example_definition(description, options={}, &block)
        ExampleDefinition.new(description, options, &block)
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
      end
    end
  end
end