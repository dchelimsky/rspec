module Spec
  module DSL
    class Behaviour < Module
      extend Forwardable
      extend BehaviourCallbacks
      include BehaviourCallbacks
      attr_accessor :description
      public :include

      def initialize(*args, &behaviour_block)
        init_description(*args)
        before_eval
        module_eval(&behaviour_block)
      end

      def included(mod) # :nodoc:
        if mod.is_a?(Behaviour)
          examples.each          { |e| mod.examples << e; }
          before_each_parts.each { |p| mod.before_each_parts << p }
          after_each_parts.each  { |p| mod.after_each_parts << p }
          before_all_parts.each  { |p| mod.before_all_parts << p }
          after_all_parts.each   { |p| mod.after_all_parts << p }
          included_modules.each  { |m| mod.include m }
        end
      end

      # Use this to pull in examples from shared behaviours.
      # See Spec::Runner for information about shared behaviours.
      def it_should_behave_like(behaviour_description)
        behaviour = SharedBehaviour.find_shared_behaviour(behaviour_description)
        unless behaviour
          raise RuntimeError.new("Shared Behaviour '#{behaviour_description}' can not be found")
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

      def define_predicate_matchers(hash) # :nodoc:
        hash.each_pair do |matcher_method, method_on_object|
          define_method matcher_method do |*args|
            eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
          end
        end
      end

      # Creates an instance of Spec::DSL::ExampleRunner and adds
      # it to a collection of examples of the current behaviour.
      def it(description=:__generate_description, opts={}, &block)
        examples << create_example_runner(description, opts, &block)
      end
      alias_method :specify, :it

      def shared?
        description[:shared]
      end

      def behaviour_type #:nodoc:
        description[:behaviour_type]
      end

      def described_type
        description.described_type
      end

      def before_each_proc(behaviour_type, &error_handler)
        parts = []
        parts.push(*Behaviour.before_each_parts(nil))
        parts.push(*Behaviour.before_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*before_each_parts(nil))
        parts.push(*before_each_parts(behaviour_type)) unless behaviour_type.nil?
        CompositeProcBuilder.new(parts).proc(&error_handler)
      end

      def before_all_proc(behaviour_type, &error_handler)
        parts = []
        parts.push(*Behaviour.before_all_parts(nil))
        parts.push(*Behaviour.before_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*before_all_parts(nil))
        parts.push(*before_all_parts(behaviour_type)) unless behaviour_type.nil?
        CompositeProcBuilder.new(parts).proc(&error_handler)
      end

      def after_all_proc(behaviour_type)
        parts = []
        parts.push(*after_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*after_all_parts(nil))
        parts.push(*Behaviour.after_all_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*Behaviour.after_all_parts(nil))
        CompositeProcBuilder.new(parts).proc
      end

      def after_each_proc(behaviour_type)
        parts = []
        parts.push(*after_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*after_each_parts(nil))
        parts.push(*Behaviour.after_each_parts(behaviour_type)) unless behaviour_type.nil?
        parts.push(*Behaviour.after_each_parts(nil))
        CompositeProcBuilder.new(parts).proc
      end

      def examples
        @examples ||= []
      end

      def number_of_examples
        examples.length
      end

      private

      def init_description(*args)
        unless self.class == Behaviour
          args << {} unless Hash === args.last
          args.last[:behaviour_class] = self.class
        end
        self.description = BehaviourDescription.new(*args)
        if described_type.class == Module
          include described_type
        end
      end

      protected

      def before_eval
      end

      public

      def run(reporter, dry_run=false, reverse=false, timeout=nil)
        raise "shared behaviours should never run" if shared?
        reporter.add_behaviour(description)
        before_all_errors = run_before_all(reporter, dry_run)

        if before_all_errors.empty?
          example = nil
          exs = reverse ? examples.reverse : examples
          exs.each do |example_runner|
            example = create_example(example_runner)
            example.copy_instance_variables_from(@before_and_after_all_example)

            befores = before_each_proc(behaviour_type) {|e| raise e}
            afters = after_each_proc(behaviour_type)
            example_runner.run(reporter, befores, afters, dry_run, example, timeout)
          end
          @before_and_after_all_example.copy_instance_variables_from(example)
        end

        run_after_all(reporter, dry_run)
      end

      def matches?(specified_examples)
        matcher ||= ExampleMatcher.new(description.to_s)

        examples.each do |example|
          return true if example.matches?(matcher, specified_examples)
        end
        return false
      end

      def retain_examples_matching!(specified_examples)
        return if specified_examples.index(description.to_s)
        matcher = ExampleMatcher.new(description.to_s)
        examples.reject! do |example|
          !example.matches?(matcher, specified_examples)
        end
      end

      # Sets the #number on each ExampleRunner and returns the next number
      def set_sequence_numbers(number, reverse) #:nodoc:
        exs = reverse ? examples.reverse : examples
        exs.each do |example|
          example.number = number
          number += 1
        end
        number
      end

      def create_example_runner(description, options={}, &block)
        ExampleRunner.new(description, options, &block)
      end

      protected

      def create_example(example)
        example_class.new(self, example)
      end

      def run_before_all(reporter, dry_run)
        errors = []
        unless dry_run
          begin
            @before_and_after_all_example = create_example(nil)
            @before_and_after_all_example.instance_eval(&before_all_proc(behaviour_type))
          rescue Exception => e
            errors << e
            location = "before(:all)"
            # The easiest is to report this as an example failure. We don't have an ExampleRunner
            # at this point, so we'll just create a placeholder.
            reporter.example_finished(create_example_runner(location), e, location) if reporter
          end
        end
        errors
      end

      def run_after_all(reporter, dry_run)
        unless dry_run
          begin
            @before_and_after_all_example ||= create_example(nil)
            @before_and_after_all_example.instance_eval(&after_all_proc(behaviour_type))
          rescue Exception => e
            location = "after(:all)"
            reporter.example_finished(create_example_runner(location), e, location) if reporter
          end
        end
      end

      def example_class
        return @example_class if @example_class
        @example_class = Class.new(example_superclass)
        @example_class.plugin_mock_framework
        @example_class.include_example_modules(self, behaviour_type)
        define_predicate_matchers(predicate_matchers)
        define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
        @example_class
      end

      def example_superclass
        Example
      end
    end
  end
end
