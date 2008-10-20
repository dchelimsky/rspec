module Spec
  module Example
    module BeforeAndAfterHooks
      # Registers a block to be executed before each example.
      # This method prepends +block+ to existing before blocks.
      def prepend_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts.unshift(block)
      end

      # Registers a block to be executed before each example.
      # This method appends +block+ to existing before blocks.
      def append_before(*args, &block)
        scope, options = scope_and_options(*args)
        parts = before_parts_from_scope(scope)
        parts << block
      end
      alias_method :before, :append_before

      # Registers a block to be executed after each example.
      # This method prepends +block+ to existing after blocks.
      def prepend_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts.unshift(block)
      end
      alias_method :after, :prepend_after

      # Registers a block to be executed after each example.
      # This method appends +block+ to existing after blocks.
      def append_after(*args, &block)
        scope, options = scope_and_options(*args)
        parts = after_parts_from_scope(scope)
        parts << block
      end

      def remove_after(scope, &block)
        after_each_parts.delete(block)
      end

      # Deprecated. Use before(:each)
      def setup(&block)
        before(:each, &block)
      end

      # Deprecated. Use after(:each)
      def teardown(&block)
        after(:each, &block)
      end

      def before_all_parts # :nodoc:
        @before_all_parts ||= []
      end

      def after_all_parts # :nodoc:
        @after_all_parts ||= []
      end

      def before_each_parts # :nodoc:
        @before_each_parts ||= []
      end

      def after_each_parts # :nodoc:
        @after_each_parts ||= []
      end
      
    private  
      
      def scope_and_options(*args)
        args, options = args_and_options(*args)
        scope = (args[0] || :each), options
      end

      def before_parts_from_scope(scope)
        case scope
        when :each; before_each_parts
        when :all; before_all_parts
        when :suite; Spec::Runner.options.before_suite_parts
        end
      end

      def after_parts_from_scope(scope)
        case scope
        when :each; after_each_parts
        when :all; after_all_parts
        when :suite; Spec::Runner.options.after_suite_parts
        end
      end

    end
  end
end