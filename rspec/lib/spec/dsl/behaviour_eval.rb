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
          parts = before_all_parts.dup
          add_behaviour_superclass_method(:context_setup, parts)
          create_block_from_parts(parts)
        end

        def after_all_block
          parts = after_all_parts.dup
          add_behaviour_superclass_method(:context_teardown, parts)
          create_block_from_parts(parts)
        end

        def setup_block
          parts = before_each_parts.dup
          add_behaviour_superclass_method(:setup, parts)
          create_block_from_parts(parts)
        end
        
        def teardown_block
          parts = after_each_parts.dup
          add_behaviour_superclass_method(:teardown, parts)
          create_block_from_parts(parts)
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

        def add_behaviour_superclass_method sym, parts
          superclass_method = begin
            context_superclass.instance_method(sym)
          rescue
            nil
          end
          parts.unshift superclass_method if superclass_method
        end

        def create_block_from_parts(parts)
          proc do
            parts.each do |part|
              if part.is_a?(UnboundMethod)
                part.bind(self).call
              else
                instance_eval(&part)
              end
            end
          end
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
