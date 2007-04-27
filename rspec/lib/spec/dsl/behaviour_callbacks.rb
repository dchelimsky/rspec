module Spec
  module DSL
    module BehaviourCallbacks
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

      protected
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
    end
  end
end
