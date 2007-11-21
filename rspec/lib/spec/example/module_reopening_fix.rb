module Spec
  module Example
    module ModuleReopeningFix
      def child_modules
        @child_modules ||= []
      end

      def included(mod)
        child_modules << mod
      end

      def include(mod)
        super
        child_modules.each do |child_module|
          child_module.__send__(:include, mod)
        end
      end
    end
  end
end