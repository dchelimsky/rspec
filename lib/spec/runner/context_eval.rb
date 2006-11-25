module Spec
  module Runner
    module ContextEval
      module ModuleMethods
        def inherit(klass)
          @context_superclass = klass
          derive_execution_context_class_from_context_superclass
        end

        def include(mod)
          context_modules << mod
        end

        def setup(&block)
          setup_parts << block
        end

        def teardown(&block)
          teardown_parts << block
        end

        def specify(spec_name, opts={}, &block)
          specifications << Specification.new(spec_name, opts, &block)
        end

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

        def setup_block
          parts = setup_parts.dup
          add_context_superclass_method(:setup, parts)
          create_block_from_parts(parts)
        end
        
        def teardown_block
          parts = teardown_parts.dup
          add_context_superclass_method(:teardown, parts)
          create_block_from_parts(parts)
        end

        def execution_context_class
          @execution_context_class ||= derive_execution_context_class_from_context_superclass
        end

        def derive_execution_context_class_from_context_superclass
          @execution_context_class = Class.new(context_superclass)
          @execution_context_class.class_eval do
            include ::Spec::Runner::ExecutionContext::InstanceMethods
          end
        end

        def context_superclass
          @context_superclass ||= Object
        end

        def context_modules
          @context_modules ||= []
        end
        
        def specifications
          @specifications ||= []
        end

        def setup_parts
          @setup_parts ||= []
        end

        def teardown_parts
          @teardown_parts ||= []
        end

        def add_context_superclass_method sym, parts
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
      end
      
    end
  end
end
