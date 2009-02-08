module Spec
  module Example

    module ExampleGroupMethods
      class << self
        attr_accessor :matcher_class
      end

      include Spec::Example::BeforeAndAfterHooks
      include Spec::Example::Subject::ExampleGroupMethods
      include Spec::Example::PredicateMatchers

      attr_reader :options, :spec_path
      
      def inherited(klass) # :nodoc:
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
            subclass(*args, &example_group_block)
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
      
      # Creates an instance of the current example group class and adds it to
      # a collection of examples of the current example group.
      def example(description=nil, options={}, backtrace=nil, &implementation)
        example_description = ExampleDescription.new(description, options, backtrace || caller(0)[1])
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

        define_methods_from_predicate_matchers

        success, before_all_instance_variables = run_before_all(run_options)
        success, after_all_instance_variables  = execute_examples(success, before_all_instance_variables, examples, run_options)
        success                                = run_after_all(success, after_all_instance_variables, run_options)
      end

      def set_description(*args)
        @description_args, @options = Spec::Example.args_and_options(*args)
        @backtrace = caller(1)
        @spec_path = File.expand_path(options[:spec_path]) if options[:spec_path]
        self
      end
      
      def notify(listener) # :nodoc:
        listener.add_example_group(self)
      end

      def description
        @description ||= build_description_from(*description_parts) || to_s
      end
      
      def described_type
        @described_type ||= description_parts.reverse.find {|part| part.is_a?(Module)}
      end
      
      def described_class
        @described_class ||= Class === described_type ? described_type : nil
      end
      
      def description_args
        @description_args ||= []
      end
      
      def description_parts #:nodoc:
        @description_parts ||= example_group_hierarchy.inject([]) do |parts, example_group_class|
          [parts << example_group_class.description_args].flatten
        end
      end
      
      def example_descriptions # :nodoc:
        @example_descriptions ||= []
      end
      
      def example_implementations # :nodoc:
        @example_implementations ||= {}
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
      
      def filtered_description(filter)
        build_description_from(
          *nested_descriptions.collect do |description|
            description =~ filter ? $1 : description
          end
        )
      end
      
      def nested_descriptions
        example_group_hierarchy.nested_descriptions
      end
      
      def include_constants_in(mod)
        include mod if (Spec::Ruby.version.to_f >= 1.9) & (Module === mod) & !(Class === mod)
      end
      
    private

      def subclass(*args, &example_group_block)
        @class_count ||= 0
        @class_count += 1
        klass = const_set("Subclass_#{@class_count}", Class.new(self))
        klass.set_description(*args)
        klass.include_constants_in(args.last[:scope])
        klass.module_eval(&example_group_block)
        klass
      end

      def dry_run(examples, run_options)
        examples.each do |example|
          run_options.reporter.example_started(example)
          run_options.reporter.example_finished(example)
        end
      end

      def run_before_all(run_options)
        return [true,{}] if example_group_hierarchy.before_all_parts.empty?
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
          example_group_instance = new(example.description,example.options,&example_implementations[example])
          success &= example_group_instance.execute(run_options, instance_variables)
          after_all_instance_variables = example_group_instance.instance_variable_hash
        end
        
        return [success, after_all_instance_variables]
      end
      
      def run_after_all(success, instance_variables, run_options)
        return success if example_group_hierarchy.after_all_parts.empty?
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
        !run_options.examples.empty?
      end

      def method_added(name) # :nodoc:
        example(name.to_s, {}, caller(0)[1]) {__send__ name.to_s} if example_method?(name.to_s)
      end
      
      def example_method?(method_name)
        should_method?(method_name)
      end

      def should_method?(method_name)
        !(method_name =~ /^should(_not)?$/) &&
        method_name =~ /^should/ &&
        instance_method(method_name).arity < 1
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

      def build_description_from(*args)
        text = args.inject("") do |description, arg|
          description << " " unless (description == "" || arg.to_s =~ /^(\s|\.|#)/)
          description << arg.to_s
        end
        text == "" ? nil : text
      end
    end

  end
end
