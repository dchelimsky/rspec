module Spec
  module DSL
    module BehaviourEval
      module ModuleMethods
        include BehaviourCallbacks

        attr_writer :behaviour
        attr_accessor :description

        def inherit(klass)
          raise ArgumentError.new("Shared behaviours cannot inherit from classes") if @behaviour.shared?
          @behaviour_superclass = klass
          derive_execution_context_class_from_behaviour_superclass
        end

        def include(mod)
          included_modules << mod
          mod.send :included, self
        end

        def it_should_behave_like(behaviour_description)
          behaviour = @behaviour.class.find_shared_behaviour(behaviour_description)
          behaviour.copy_to(self)
        end

        def copy_to(eval_module)
          examples.each          { |e| eval_module.examples << e; }
          before_each_parts.each { |p| eval_module.before_each_parts << p }
          after_each_parts.each  { |p| eval_module.after_each_parts << p }
          before_all_parts.each  { |p| eval_module.before_all_parts << p }
          after_all_parts.each   { |p| eval_module.after_all_parts << p }
          included_modules.each  { |m| eval_module.included_modules << m }
        end

        # Deprecated - use "before(:each) { ... }"
        alias :setup :before

        # Deprecated - use "after(:each) { ... }"
        alias :teardown :after

        # Deprecated - use "before(:all) { ... }"
        def context_setup(&block)
          before(:all, &block)
        end

        # Deprecated - use "after(:all) { ... }"
        def context_teardown(&block)
          after(:all, &block)
        end

        def it(description=:__generate_description, opts={}, &block)
          examples << Example.new(description, opts, &block)
        end
        alias :specify :it

        def methods
          my_methods = super
          my_methods |= behaviour_superclass.methods
          my_methods
        end

      protected

        def method_missing(method_name, *args)
          if behaviour_superclass.respond_to?(method_name)
            return execution_context_class.send(method_name, *args)
          end
          super
        end

        def before_all_proc(&error_handler)
          parts = []
          parts.push(*Behaviour.before_all_parts)
          add_superclass_method(parts, 'context_setup')
          parts.push(*before_all_parts)
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def after_all_proc(&error_handler)
          parts = []
          parts.push(*after_all_parts)
          add_superclass_method(parts, 'context_teardown')
          parts.push(*Behaviour.after_all_parts)
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def before_each_proc(&error_handler)
          parts = []
          add_superclass_method(parts, 'setup')
          parts.push(*Behaviour.before_each_parts)
          parts.push(*before_each_parts)
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def after_each_proc(&error_handler)
          parts = []
          parts.push(*after_each_parts)
          add_superclass_method(parts, 'teardown')
          parts.push(*Behaviour.after_each_parts)
          CompositeProcBuilder.new(parts).proc(&error_handler)
        end

        def add_superclass_method(parts, method_name)
          parts << behaviour_superclass.instance_method(method_name) if behaviour_superclass.instance_methods.include?(method_name)
        end

      private

        def execution_context_class
          @execution_context_class ||= derive_execution_context_class_from_behaviour_superclass
        end

        def derive_execution_context_class_from_behaviour_superclass
          @execution_context_class = Class.new(behaviour_superclass)
        end

        def behaviour_superclass
          @behaviour_superclass ||= Object
        end

        protected
        def included_modules
          @included_modules ||= [::Spec::Matchers]
        end

        def examples
          @examples ||= []
        end
      end

      module InstanceMethods
        def initialize(*args, &block) #:nodoc:
          # TODO - inheriting from TestUnit::TestCase fails without this
          # - let's figure out why and move this somewhere else
        end

        def violated(message="")
          raise Spec::Expectations::ExpectationNotMetError.new(message)
        end

      end

    end
  end
end
