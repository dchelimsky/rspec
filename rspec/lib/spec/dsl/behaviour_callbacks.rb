module Spec
  module DSL
    module BehaviourCallbacks
      def prepend_before(scope=:each, &block)
        case scope
        when :each; before_each_parts.unshift(block)
        when :all;  before_all_parts.unshift(block)
        end
      end
      def append_before(scope=:each, &block)
        case scope
        when :each; before_each_parts << block
        when :all;  before_all_parts << block
        end
      end
      alias_method :before, :append_before

      def prepend_after(scope=:each, &block)
        case scope
        when :each; after_each_parts.unshift(block)
        when :all;  after_all_parts.unshift(block)
        end
      end
      alias_method :after, :prepend_after
      def append_after(scope=:each, &block)
        case scope
        when :each; after_each_parts << block
        when :all;  after_all_parts << block
        end
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
    end
  end
end
