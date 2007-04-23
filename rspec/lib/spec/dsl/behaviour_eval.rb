module Spec
  module DSL
    module BehaviourEval
      module ModuleMethods
        def inherit(klass)
          @behaviour_superclass = klass
          derive_execution_context_class_from_context_superclass
        end

        def include(mod)
          context_modules << mod
          mod.send :included, self
        end

        def before(scope=:each, &block)
          case scope
          when :each; before_each_parts << block
          when :all;  before_all_parts << block
          end
        end

        def after(scope=:each, &block)
          case scope
          when :each; after_each_parts << block
          when :all;  after_all_parts << block
          end
        end

        # Backwards compatibility - should we deprecate?
        alias :setup :before

        # Backwards compatibility - should we deprecate?
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
          my_methods |= context_superclass.methods
          my_methods
        end

      protected

        def method_missing(method_name, *args)
          if context_superclass.respond_to?(method_name)
            return execution_context_class.send(method_name, *args)
          end
          super
        end

      private

        def before_all_block
          create_callback_proc :context_setup, before_all_parts
        end

        def after_all_block
          create_callback_proc :context_teardown, after_all_parts
        end

        def setup_block
          create_callback_proc :setup, before_each_parts
        end

        def teardown_block
          create_callback_proc :teardown, after_each_parts
        end

        def create_callback_proc(superclass_method_name, parts)
          builder = CompositeProcBuilder.new(self)
          builder.add_instance_method_from(context_superclass, superclass_method_name)
          builder.push(*parts)
          builder.proc
        end

        def execution_context_class
          @execution_context_class ||= derive_execution_context_class_from_context_superclass
        end

        def derive_execution_context_class_from_context_superclass
          @execution_context_class = Class.new(context_superclass)
        end

        def context_superclass
          @behaviour_superclass ||= Object
        end

        def context_modules
          @context_modules ||= [::Spec::Matchers]
        end

        def examples
          @examples ||= []
        end

        def before_all_parts
          @before_all_parts ||= []
        end

        def after_all_parts
          @after_all_parts ||= []
        end

        def before_each_parts
          @before_each_parts ||= []
        end

        def after_each_parts
          @after_each_parts ||= []
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
