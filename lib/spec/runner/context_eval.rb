module Spec
  module Runner
    module ContextEval
      module ModuleMethods
        def inherit(klass)
          @context_superclass = klass
          derive_execution_context_class_from context_superclass
        end

        def include(mod)
          context_modules << mod
        end

        def setup(&block)
          @setup_block = block
        end

        def teardown(&block)
          @teardown_block = block
        end

        def specify(spec_name, &block)
          specifications << Specification.new(spec_name, &block)
        end

        def methods
          my_methods = super
          my_methods |= context_superclass.methods
          my_methods
        end
        protected

        def method_missing(method_name, *args)
          if context_superclass
            return context_superclass.send(method_name, *args)
          end
          super
        end

        def specifications
          @specifications ||= []
        end

        attr_accessor :setup_block
        attr_accessor :teardown_block

        def derive_execution_context_class_from(context_superclass)
          @execution_context_class = Class.new(context_superclass)
          @execution_context_class.class_eval do
            include ::Spec::Runner::ExecutionContext::InstanceMethods
          end
        end

        def execution_context_class
          @execution_context_class ||= begin
            derive_execution_context_class_from context_superclass
          end
        end
        def context_superclass
          @context_superclass ||= Object
        end

        def context_modules
          @context_modules ||= []
        end
      end
    end
  end
end
