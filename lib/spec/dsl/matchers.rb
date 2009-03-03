module Spec
  module DSL
    module Matchers
      def create(name, &block_passed_to_create)
        self.class.class_eval do
          define_method name do |expected|
            Spec::Matchers::Matcher.new name, expected, &block_passed_to_create
          end
        end
      end
    end
  end
end

Spec::Matchers.extend Spec::DSL::Matchers