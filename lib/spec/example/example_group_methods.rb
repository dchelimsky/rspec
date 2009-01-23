module Spec
  module Example

    module ExampleGroupMethods
      class << self
        attr_accessor :matcher_class
      end

      include Spec::Example::BeforeAndAfterHooks
      include Spec::Example::Subject::ExampleGroupMethods

      attr_reader :description_options, :spec_path
      alias :options :description_options
      
      def inherited(klass)
        super
        ExampleGroupFactory.register_example_group(klass)
      end
      
      # Provides the backtrace up to where this example_group was declared.
      def backtrace
        @backtrace
      end

      # Deprecated - use +backtrace()+
      def example_group_backtrace
        Kernel.warn <<-WARNING
ExampleGroupMethods#example_group_backtrace is deprecated and will be removed
from a future version. Please use ExampleGroupMethods#backtrace instead.
WARNING
        backtrace
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
          Spec::Example::add_spec_path_to(args)
          options = args.last
          if options[:shared]
            ExampleGroupFactory.create_shared_example_group(*args, &example_group_block)
          else
            ExampleGroupFactory.create_example_group_subclass(self, *args, &example_group_block)
          end
        else
          set_description(*args)
        end
      end
      alias :context :describe
      
      # Use this to pull in examples from shared example groups.
      def it_should_behave_like(*shared_example_groups)
        shared_example_groups.each do |group|
          include_shared_example_group(group)
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
      #   exist (for state expectations)
      #     File.should exist("path/to/file")
      #
      #   an_instance_of (for mock argument matchers)
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
        @predicate_matchers ||= {}
      end

      def example_descriptions
        @example_descriptions ||= []
      end
      
      def example_implementations
        @example_implementations ||= {}
      end

      # Creates an instance of the current example group class and adds it to
      # a collection of examples of the current example group.
      def example(description=nil, options={}, backtrace=nil, &implementation)
        example_description = ExampleDescription.new(description, backtrace || caller(0)[1])
        example_descriptions << example_description
        example_implementations[example_description] = implementation
        example_description
      end

      alias_method :it, :example
      alias_method :specify, :example

      # Use this to temporarily disable an example.
      def xexample(description=nil, opts={}, &block)
        Kernel.warn("Example disabled: #{description}")
      end
      
      alias_method :xit, :xexample
      alias_method :xspecify, :xexample
      
      def run(run_options)
        examples = examples_to_run(run_options)
        notify(run_options.reporter) unless examples.empty?
        return true if examples.empty?
        return dry_run(examples, run_options) if run_options.dry_run?

        plugin_mock_framework(run_options)
        define_methods_from_predicate_matchers(run_options)

        success, before_all_instance_variables = run_before_all(run_options)
        success, after_all_instance_variables  = execute_examples(success, before_all_instance_variables, examples, run_options)
        success                                = run_after_all(success, after_all_instance_variables, run_options)
      end

      def set_description(*args)
        args, options = Spec::Example.args_and_options(*args)
        @description_args = args
        @description_options = options
        @backtrace = caller(1)
        @spec_path = File.expand_path(options[:spec_path]) if options[:spec_path]
        self
      end
      
      def notify(listener) # :nodoc:
        listener.add_example_group(description_object)
      end

      # FIXME - why do we need description object and description methods?
      def description_object
        @description_object ||= ExampleGroupDescription.new(example_group_hierarchy)
      end
      
      def description
        description_object.description
      end
      
      def described_type
        @described_type ||= description_parts.reverse.find {|part| part.is_a?(Module)}
      end
      
      def described_class
        Class === described_type ? described_type : nil
      end
      
      def description_args
        @description_args ||= []
      end
      
      def description_parts #:nodoc:
        @description_parts ||= example_group_hierarchy.inject([]) do |parts, example_group_class|
          [parts << example_group_class.description_args].flatten
        end
      end
            
      def examples(run_options=nil) #:nodoc:
        (run_options && run_options.reverse) ? example_descriptions.reverse : example_descriptions
      end

      def number_of_examples #:nodoc:
        example_descriptions.length
      end

      def example_group_hierarchy
        @example_group_hierarchy ||= ExampleGroupHierarchy.new(self)
      end
      
    private
      def dry_run(examples, run_options)
        examples.each do |example|
          run_options.reporter.example_started(example)
          run_options.reporter.example_finished(example)
        end
      end

      def run_before_all(run_options)
        before_all = new("before(:all)")
        begin
          example_group_hierarchy.run_before_all(before_all)
          return [true, before_all.instance_variable_hash]
        rescue Exception => e
          run_options.reporter.example_failed(ExampleDescription.new("before(:all)"), e)
          return [false, before_all.instance_variable_hash]
        end
      end

      def execute_examples(success, instance_variables, examples, run_options)
        return [success, instance_variables] unless success

        after_all_instance_variables = instance_variables
        
        examples.each do |example|
          example_group_instance = new(example.description,{},&example_implementations[example])
          success &= example_group_instance.execute(run_options, instance_variables)
          after_all_instance_variables = example_group_instance.instance_variable_hash
        end
        
        return [success, after_all_instance_variables]
      end
      
      def run_after_all(success, instance_variables, run_options)
        after_all = new("after(:all)")
        after_all.set_instance_variables_from_hash(instance_variables)
        example_group_hierarchy.run_after_all(after_all)
        return success
      rescue Exception => e
        run_options.reporter.example_failed(ExampleDescription.new("after(:all)"), e)
        return false
      end
      
      def examples_to_run(run_options)
        return example_descriptions unless specified_examples?(run_options)
        example_descriptions.reject do |example|
          matcher = ExampleGroupMethods.matcher_class.
            new(description.to_s, example.description)
          !matcher.matches?(run_options.examples)
        end
      end

      def specified_examples?(run_options)
        run_options.examples && !run_options.examples.empty?
      end

      def plugin_mock_framework(run_options)
        case mock_framework = run_options.mock_framework
        when Module
          include mock_framework
        else
          require mock_framework
          include Spec::Adapters::MockFramework
        end
      end

      def define_methods_from_predicate_matchers(run_options) # :nodoc:
        all_predicate_matchers = predicate_matchers.merge(
          run_options.predicate_matchers
        )
        all_predicate_matchers.each_pair do |matcher_method, method_on_object|
          define_method matcher_method do |*args|
            eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
          end
        end
      end

      def method_added(name)
        example(name.to_s, {}, caller(0)[1]) {__send__ name.to_s} if example_method?(name.to_s)
      end
      
      def example_method?(method_name)
        should_method?(method_name)
      end

      def should_method?(method_name)
        !(method_name =~ /^should(_not)?$/) &&
        method_name =~ /^should/ && (
          [-1,0].include?(instance_method(method_name).arity)
        )
      end

      def include_shared_example_group(shared_example_group)
        case shared_example_group
        when SharedExampleGroup
          include shared_example_group
        else
          example_group = SharedExampleGroup.find(shared_example_group)
          unless example_group
            raise RuntimeError.new("Shared Example Group '#{shared_example_group}' can not be found")
          end
          include(example_group)
        end
      end

      class ExampleGroupHierarchy < Array
        def initialize(example_group_class)
          current_class = example_group_class
          while current_class.kind_of?(ExampleGroupMethods)
            unshift(current_class)
            break unless current_class.respond_to? :superclass
            current_class = current_class.superclass
          end
        end
        
        def run_before_all(example)
          each {|klass| example.eval_each_fail_fast(klass.before_all_parts)}
        end
        
        def run_before_each(example)
          each {|klass| example.eval_each_fail_fast(klass.before_each_parts)}
        end
        
        def run_after_each(example)
          example.eval_each_fail_slow(after_each_parts)
        end
        
        def run_after_all(example)
          example.eval_each_fail_slow(after_all_parts)
        end
        
        def after_each_parts
          reverse.inject([]) do |parts, klass|
            parts += klass.after_each_parts
          end
        end
        
        def after_all_parts
          reverse.inject([]) do |parts, klass|
            parts += klass.after_all_parts
          end
        end
        
        def nested_description_from(example_group)
          example_group.description_args.join
        end
        
        def nested_descriptions
          collect {|eg| nested_description_from(eg) == "" ? nil : nested_description_from(eg) }.compact
        end
      end
      
    end

  end
end
