module Spec
  module Example

    # See http://rspec.rubyforge.org/documentation/before_and_after.html
    module ExampleGroupMethods
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
      #   class StackSpec < Spec::ExampleGroup
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
      def describe(*args, &example_group_block)
        if example_group_block
          args.unshift(description) unless description.nil?
          Class.new(self) do
            describe(*args)
            register
            module_eval(&example_group_block)
          end
        else
          set_description(*args)
          before_eval
          self
        end
      end

      # Use this to pull in examples from shared behaviours.
      # See Spec::Runner for information about shared behaviours.
      def it_should_behave_like(shared_example_group)
        case shared_example_group
        when SharedExampleGroup
          include shared_example_group
        else
          example_group = SharedExampleGroup.find_shared_example_group(shared_example_group)
          unless example_group
            raise RuntimeError.new("Shared Example Group '#{shared_example_group}' can not be found")
          end
          include(example_group)
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

      # Creates an instance of Spec::Example::Example and adds
      # it to a collection of examples of the current behaviour.
      def it(description=:__generate_docstring, &implementation)
        example = create_example(description, &implementation)
        example_objects << example
        example
      end
      
      alias_method :specify, :it
      
      # Use this to temporarily disable an example.
      def xit(description=:__generate_docstring, opts={}, &block)
        Kernel.warn("Example disabled: #{description}")
      end

      def run(examples=examples_to_run)
        customize_example
        return true if examples.empty?

        reporter.add_example_group(description)
        before_and_after_all_example = new(nil)
        success = run_before_all(before_and_after_all_example)
        if success
          example_group_instance = nil
          examples.each do |example|
            example_group_instance = new(example)
            example_group_instance.copy_instance_variables_from(before_and_after_all_example)

            runner = ExampleRunner.new(rspec_options, example_group_instance)
            unless runner.run
              success = false
            end
          end
          before_and_after_all_example.copy_instance_variables_from(example_group_instance)
        end

        unless run_after_all(before_and_after_all_example)
          success = false
        end
        return success
      end

      def add_example(example)
        example_objects << example
      end

      def described_type #:nodoc:
        description.described_type
      end

      def examples #:nodoc:
        examples = example_objects.dup
        add_method_examples(examples)
        rspec_options.reverse ? examples.reverse : examples
      end
      
      def number_of_examples #:nodoc:
        examples.length
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
      def reset # :nodoc:
        @before_all_parts = nil
        @after_all_parts = nil
        @before_each_parts = nil
        @after_each_parts = nil
      end
      
      def register
        rspec_options.add_example_group self
      end

      def unregister
        rspec_options.remove_example_group self
      end

      def run_before_each(example)
        execute_in_class_hierarchy(false) do |example_group|
          example.eval_each_fail_fast(example_group.before_each_parts)
        end
      end
      
      def run_before_all(example)
        return true if dry_run
        execute_in_class_hierarchy(false) do |example_group|
          example.eval_each_fail_fast(example_group.before_all_parts)
        end
        return true
      rescue Exception => e
        location = "before(:all)"
        # The easiest is to report this as an example failure. We don't have an Example
        # at this point, so we'll just create a placeholder.
        reporter.example_finished(create_example(location), e, location)
        return false
      end

      def run_after_all(example)
        return true if dry_run
        execute_in_class_hierarchy(true) do |example_group|
          example.eval_each_fail_slow(example_group.after_all_parts)
        end
        return true
      rescue Exception => e
        location = "after(:all)"
        reporter.example_finished(create_example(location), e, location)
        return false
      end
      
      def run_after_each(example)
        execute_in_class_hierarchy(true) do |example_group|
          example.eval_each_fail_slow(example_group.after_each_parts)
        end
      end

    private
      def create_example(description, &implementation) #:nodoc:
        Example.new(description, &implementation)
      end

      def examples_to_run
        all_examples = examples
        return all_examples unless specified_examples?
        all_examples.reject do |example|
          matcher = ExampleMatcher.new(description.to_s, example.description)
          !matcher.matches?(specified_examples)
        end
      end

      def specified_examples?
        specified_examples && !specified_examples.empty?
      end

      def specified_examples
        rspec_options.examples
      end

      def reporter
        rspec_options.reporter
      end

      def dry_run
        rspec_options.dry_run
      end
      
      def example_objects
        @example_objects ||= []
      end

      def customize_example
        plugin_mock_framework
        define_predicate_matchers predicate_matchers
        define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
      end

      def execute_in_class_hierarchy(superclass_first)
        classes = []
        current_class = self
        while is_example_group?(current_class)
          superclass_first ? classes << current_class : classes.unshift(current_class)
          current_class = current_class.superclass
        end
        superclass_first ? classes << ExampleMethods : classes.unshift(ExampleMethods)

        classes.each do |behaviour|
          yield behaviour
        end
      end
      
      def is_example_group?(klass)
        klass.kind_of?(ExampleGroupMethods)
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
          args.last[:example_group] = self
        end
        self.description = ExampleGroupDescription.new(*args)
        if described_type.class == Module
          include described_type
        end
        self.description
      end
      
      def add_method_examples(examples)
        instance_methods.sort.each do |method_name|
          if example_method?(method_name)
            examples << create_example(method_name) do
              __send__(method_name)
            end
          end
        end
      end
      
      def example_method?(method_name)
        should_method?(method_name)
      end
      
      def should_method?(method_name)
        !(method_name =~ /^should(_not)?$/) && 
        method_name =~ /^should/ && (
          instance_method(method_name).arity == 0 ||
          instance_method(method_name).arity == -1
        )
      end
    end
    
  end
end