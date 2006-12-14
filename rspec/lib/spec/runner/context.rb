module Spec
  module Runner
    class ContextEvalModule < Module
    end
    class Context
      module InstanceMethods
        def initialize(name, &context_block)
          @name = name

          @context_eval_module = ContextEvalModule.new
          @context_eval_module.extend ContextEval::ModuleMethods
          @context_eval_module.include ContextEval::InstanceMethods
          before_context_eval
          @context_eval_module.class_eval(&context_block)
        end

        def before_context_eval
        end

        def inherit(klass)
          @context_eval_module.inherit klass
        end
        alias :inherit_context_eval_module_from :inherit

        def include(mod)
          @context_eval_module.include mod
        end

        def setup(&block)
          @context_eval_module.setup(&block)
        end

        def teardown(&block)
          @context_eval_module.teardown(&block)
        end

        def specify(spec_name, opts={}, &block)
          @context_eval_module.specify(spec_name, opts, &block)
        end

        def run(reporter, dry_run=false)
          reporter.add_context(@name)

          prepare_execution_context_class
          specifications.each do |specification|
            specification.run(reporter, setup_block, teardown_block, dry_run, execution_context(specification))
          end
        end
        
        def execution_context specification
          execution_context_class.new(specification)
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

        def method_missing(*args)
          @context_eval_module.method_missing(*args)
        end

        def specifications
          @context_eval_module.send :specifications
        end

        def setup_block
          @context_eval_module.send :setup_block
        end

        def teardown_block
          @context_eval_module.send :teardown_block
        end

        def prepare_execution_context_class
          weave_in_context_modules
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

        def context_modules
          @context_eval_module.send :context_modules
        end

        def execution_context_class
          @context_eval_module.send :execution_context_class
        end

      end
      include InstanceMethods
    end
  end
end
