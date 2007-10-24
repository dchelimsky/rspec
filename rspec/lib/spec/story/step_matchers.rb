module Spec
  module Story
    class StepMatchers
      def self.steps
        @step_group ||= StepMatchers.new(false)
        yield @step_group if block_given?
        @step_group
      end
      
      def initialize(init_defaults=true)
        @hash_of_lists_of_steps = Hash.new {|h, k| h[k] = []}
        if init_defaults
          self.class.steps.add_to(self)
        end
        yield self if block_given?
      end
      
      def find(type, name)
        @hash_of_lists_of_steps[type].each do |matcher|
          return matcher if matcher.matches?(name)
        end
        return nil
      end
      
      def given(name, &block)
        create_matcher(:given, name, &block)
      end
      
      def when(name, &block)
        create_matcher(:when, name, &block)
      end
      
      def then(name, &block)
        create_matcher(:then, name, &block)
      end
      
      def add(type, list_of_new_matchers)
        (@hash_of_lists_of_steps[type] << list_of_new_matchers).flatten!
      end
      
      def add_to(other_step_matchers)
        [:given, :when, :then].each do |type|
          other_step_matchers.add(type, @hash_of_lists_of_steps[type])
        end
      end
      
      def <<(other_step_matchers)
        other_step_matchers.add_to(self)
      end
      
      # TODO - make me private
      def create_matcher(type, name, &block)
        matcher = StepMatcher.new(name, &block)
        @hash_of_lists_of_steps[type] << matcher
        matcher
      end
    end
  end
end
