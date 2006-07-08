module Spec
  module Runner
    class Context
      module InstanceMethods
        def initialize(name, &context_block)
          @setup_block = nil
          @teardown_block = nil
          @specifications = []
          @name = name
          instance_exec(&context_block)
        end

        def inherit(klass)
          @context_superclass = klass
          create_execution_context_class
        end

        def include(mod)
          context_modules << mod
        end

        def run(reporter, dry_run=false)
          reporter.add_context(@name)

          prepare_execution_context_class
          @specifications.each do |specification|
            execution_context = execution_context_class.new(specification)
            specification.run(reporter, @setup_block, @teardown_block, dry_run, execution_context)
          end
        end

        def setup(&block)
          @setup_block = block
        end

        def teardown(&block)
          @teardown_block = block
        end

        def specify(spec_name, &block)
          @specifications << Specification.new(spec_name, &block)
        end

        def number_of_specs
          @specifications.length
        end

        def matches? name, matcher=nil
          matcher ||= SpecMatcher.new name, @name
          @specifications.each do |spec|
            return true if spec.matches_matcher? matcher
          end
          return false
        end

        def run_single_spec name
          return if @name == name
          matcher = SpecMatcher.new name, @name
          @specifications.reject! do |spec|
            !spec.matches_matcher? matcher
          end
        end

        protected
        def method_missing(method_name, *args)
          if context_superclass
            return context_superclass.send(method_name, *args)
          end
          super
        end

        def create_execution_context_class
          @execution_context_class = Class.new(context_superclass)
          @execution_context_class.class_eval do
            include ::Spec::Runner::ExecutionContext::InstanceMethods
          end
        end

        def prepare_execution_context_class
          mods = context_modules
          execution_context_class.class_eval do
            mods.each do |mod|
              include mod
            end
          end

          if context_superclass.method_defined?(:setup)
            super_setup = context_superclass.instance_method(:setup)
            context_setup = @setup_block if @setup_block

            @setup_block = proc do
              super_setup.bind(self).call
              instance_exec(&context_setup) if context_setup
            end
          end

          if context_superclass.method_defined?(:teardown)
            super_teardown = context_superclass.instance_method(:teardown)
            context_teardown = @teardown_block if @teardown_block

            @teardown_block = proc do
              super_teardown.bind(self).call
              instance_exec(&context_teardown) if context_teardown
            end
          end
          execution_context_class
        end

        def execution_context_class
          @execution_context_class ||= begin
            create_execution_context_class
          end
        end
        def context_superclass
          @context_superclass ||= Object
        end

        def context_modules
          @context_modules ||= []
        end
      end
      include InstanceMethods
    end
  end
end
