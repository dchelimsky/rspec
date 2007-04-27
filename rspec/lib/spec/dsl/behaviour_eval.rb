module Spec
  module DSL
    module BehaviourEval
      module ModuleMethods
        def before(scope=:each, &block)
          case scope
          when :each; before_each_parts << block
          when :all;  before_all_parts << block
          end
        end

        def after(scope=:each, &block)
          case scope
          when :each; after_each_parts.unshift(block)
          when :all;  after_all_parts.unshift(block)
          end
        end        

        def inherit(klass)
          @behaviour_superclass = klass
          derive_execution_context_class_from_context_superclass
        end

        def include(mod)
          context_modules << mod
          mod.send :included, self
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

        def before_all_proc(&error_handler)
          parts = []
          add_superclass_method(parts, 'context_setup')
          parts.push(*before_all_parts)
          CompositeProcBuilder.new(self, parts).proc(&error_handler)
        end

        def after_all_proc(&error_handler)
          parts = []
          add_superclass_method(parts, 'context_teardown')
          parts.push(*after_all_parts)
          CompositeProcBuilder.new(self, parts).proc(&error_handler)
        end

        def before_each_proc(&error_handler)
          parts = []
          add_superclass_method(parts, 'setup')
          parts.push(*before_each_parts)
          CompositeProcBuilder.new(self, parts).proc(&error_handler)
        end

        def after_each_proc(&error_handler)
          parts = []
          add_superclass_method(parts, 'teardown')
          parts.push(*after_each_parts)
          CompositeProcBuilder.new(self, parts).proc(&error_handler)
        end

        def add_superclass_method(parts, method_name)
          parts << context_superclass.instance_method(method_name) if context_superclass.instance_methods.include?(method_name)
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

      private

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
