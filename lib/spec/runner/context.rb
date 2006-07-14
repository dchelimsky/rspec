module Spec
  module Runner
    class Context
      module InstanceMethods
        def initialize(name, &context_block)
          @name = name

          @context_eval_module = Module.new
          @context_eval_module.extend ContextEval::ModuleMethods
          @context_eval_module.class_eval &context_block
        end

        def inherit(klass)
          @context_eval_module.inherit klass
        end

        def include(mod)
          @context_eval_module.include mod
        end

        def setup(&block)
          @context_eval_module.setup &block
        end

        def teardown(&block)
          @context_eval_module.teardown &block
        end

        def specify(spec_name, &block)
          @context_eval_module.specify spec_name, &block
        end

        def run(reporter, dry_run=false)
          reporter.add_context(@name)

          prepare_execution_context_class
          specifications.each do |specification|
            execution_context = execution_context_class.new(specification)
            specification.run(reporter, setup_block, teardown_block, dry_run, execution_context)
          end
        end

        def number_of_specs
          specifications.length
        end

        def matches? name, matcher=nil
          matcher ||= SpecMatcher.new name, @name
          specifications.each do |spec|
            return true if spec.matches_matcher? matcher
          end
          return false
        end

        def run_single_spec name
          return if @name == name
          matcher = SpecMatcher.new name, @name
          specifications.reject! do |spec|
            !spec.matches_matcher? matcher
          end
        end

        def methods
          my_methods = super
          my_methods |= @context_eval_module.methods
          my_methods
        end

        protected

        def method_missing(method_name, *args)
          @context_eval_module.send(method_name, *args)
        end

        def specifications
          @context_eval_module.send :specifications
        end

        def setup_block
          @context_eval_module.send :setup_block
        end
        def setup_block=(value)
          @context_eval_module.send :setup_block=, value
        end

        def teardown_block
          @context_eval_module.send :teardown_block
        end
        def teardown_block=(value)
          @context_eval_module.send :teardown_block=, value
        end

        def prepare_execution_context_class
          weave_in_context_modules
          weave_in_setup_method
          weave_in_teardown_method
          execution_context_class
        end

        def weave_in_context_modules
          mods = context_modules
          context_eval_module = @context_eval_module
          execution_context_class.class_eval do
            include context_eval_module
            mods.each do |mod|
              include mod
            end
          end
        end

        def weave_in_setup_method
          if context_superclass.method_defined?(:setup)
            super_setup = context_superclass.instance_method(:setup)
            context_setup = setup_block if setup_block

            self.setup_block = proc do
              super_setup.bind(self).call
              instance_exec(&context_setup) if context_setup
            end
          end
        end

        def weave_in_teardown_method
          if context_superclass.method_defined?(:teardown)
            super_teardown = context_superclass.instance_method(:teardown)
            context_teardown = teardown_block if teardown_block

            self.teardown_block = proc do
              super_teardown.bind(self).call
              instance_exec(&context_teardown) if context_teardown
            end
          end
        end

        def context_modules
          @context_eval_module.send :context_modules
        end

        def execution_context_class
          @context_eval_module.send :execution_context_class
        end

        def context_superclass
          @context_eval_module.send :context_superclass
        end
      end
      include InstanceMethods
    end
  end
end
