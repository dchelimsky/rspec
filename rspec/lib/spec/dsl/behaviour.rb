module Spec
  module DSL
    # See http://rspec.rubyforge.org/documentation/before_and_after.html
    module Behaviour
      attr_accessor :description

      def inherited(klass)
        super
        unless klass.name.to_s == ""
          klass.describe(klass.name)
          klass.register
        end
      end

      # Makes the describe/it syntax available from a class. For example:
      #
      #   class StackSpec < ExampleGroup
      #     describe Stack, "with no elements"
      #
      #     before
      #       @stack = Stack.new
      #     end
      #
      #     it "should raise on pop" do
      #       lambda{ @stack.pop }.should raise_error
      #     end
      #   end
      #
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

      def described_type #:nodoc:
        description.described_type
      end

      def example_definitions #:nodoc:
        @example_definitions ||= []
      end

      def number_of_examples #:nodoc:
        example_definitions.length
      end

      def create_example_definition(description, options={}, &block) #:nodoc:
        ExampleDefinition.new(description, options, &block)
      end

      # Registers a block to be executed before each example.
      # This method prepends +block+ to existing before blocks.
      def prepend_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts.unshift(block)
      end

      # Registers a block to be executed before each example.
      # This method appends +block+ to existing before blocks.
      def append_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts << block
      end
      alias_method :before, :append_before

      # Registers a block to be executed after each example.
      # This method prepends +block+ to existing after blocks.
      def prepend_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts.unshift(block)
      end
      alias_method :after, :prepend_after

      # Registers a block to be executed after each example.
      # This method appends +block+ to existing after blocks.
      def append_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts << block
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

      # Only used from RSpec's own examples
      def reset! # :nodoc:
        @before_all_parts = nil
        @after_all_parts = nil
        @before_each_parts = nil
        @after_each_parts = nil
      end
      
      def suite
        description = description ? description.description : "RSpec Description Suite"
        customize_example
        suite = ExampleSuite.new(description, self)
        ordered_example_definitions.each do |example_definition|
          suite << new(example_definition)
        end
        add_examples_from_methods(suite)
        suite
      end
      
      # Sets the #number on each ExampleDefinition and returns the next number
      def set_sequence_numbers(number) #:nodoc:
        ordered_example_definitions.each do |example_definition|
          example_definition.number = number
          number += 1
        end
        number
      end

      def register
        rspec_options.add_behaviour self
      end

      def run_before_each(example)
        execute_in_class_hierarchy(false) do |behaviour|
          example.eval_each_fail_fast(behaviour.before_each_parts)
        end
      end
      
      def run_before_all(example)
        execute_in_class_hierarchy(false) do |behaviour|
          example.eval_each_fail_fast(behaviour.before_all_parts)
        end
      end

      def run_after_all(example)
        execute_in_class_hierarchy(true) do |behaviour|
          example.eval_each_fail_slow(behaviour.after_all_parts)
        end
      end
      
      def run_after_each(example)
        execute_in_class_hierarchy(true) do |behaviour|
          example.eval_each_fail_slow(behaviour.after_each_parts)
        end
      end

    private

      def customize_example
        plugin_mock_framework
        define_predicate_matchers predicate_matchers
        define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
      end

      def execute_in_class_hierarchy(superclass_first)
        classes = []
        current_class = self
        while current_class.is_a?(Behaviour)
          superclass_first ? classes << current_class : classes.unshift(current_class)
          current_class = current_class.superclass
        end

        classes.each do |behaviour|
          yield behaviour
        end
      end

      def add_examples_from_methods(suite)
        instance_methods.each do |method_name|
          if (is_test?(method_name) || is_spec?(method_name)) && (
            instance_method(method_name).arity == 0 ||
            instance_method(method_name).arity == -1
          )
            example_definition = ExampleDefinition.new(method_name) do
              __send__ method_name
            end
            suite << new(example_definition)
          end
        end
      end

      def is_test?(method_name)
        method_name =~ /^test_./
      end
      
      def is_spec?(method_name)
        !(method_name =~ /^should(_not)?$/) && method_name =~ /^should/
      end

      def ordered_example_definitions
        rspec_options.reverse ? example_definitions.reverse : example_definitions
      end

      def plugin_mock_framework
        case mock_framework = Spec::Runner.configuration.mock_framework
        when Module
          include mock_framework
        else
          require Spec::Runner.configuration.mock_framework
          include Spec::Plugins::MockFramework
        end
      end

      def define_predicate_matchers(definitions) # :nodoc:
        definitions.each_pair do |matcher_method, method_on_object|
          define_method matcher_method do |*args|
            eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
          end
        end
      end

      def scope_and_options(*args)
        args, options = args_and_options(*args)
        scope = (args[0] || :each), options
      end

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
        unless self.class == ExampleGroup
          args << {} unless Hash === args.last
          args.last[:behaviour] = self
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