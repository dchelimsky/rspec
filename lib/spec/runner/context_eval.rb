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
          if context_superclass.respond_to?(method_name)
            return execution_context_class.send(method_name, *args)
          end
          super
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

        def setup_block
          parts = setup_parts.dup

          setup_method = begin
            context_superclass.instance_method(:setup)
          rescue
            nil
          end
          parts.unshift setup_method if setup_method
          create_block_from_parts(parts)
        end

        def teardown_block
          parts = teardown_parts.dup

          teardown_method = begin
            context_superclass.instance_method(:teardown)
          rescue
            nil
          end
          parts.unshift teardown_method if teardown_method
          create_block_from_parts(parts)
        end

        def create_block_from_parts(parts)
          proc do
            parts.each do |part|
              if part.is_a?(UnboundMethod)
                part.bind(self).call
              else
                instance_exec(&part)
              end
            end
          end
        end

        def execution_context_class
          return @execution_context_class if @execution_context_class
          derive_execution_context_class_from_context_superclass
          @execution_context_class
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
      end
      module InstanceMethods
      end
    end
  end
end
