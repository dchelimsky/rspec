module Spec
  module Expectations
    # This module adds syntactic sugar that allows usage of should_* instead of should.*
    module UnderscoreSugar
      def handle_underscores_for_rspec!
        original_method_missing = instance_method(:method_missing)
        class_eval do
          def method_missing(sym, *args, &block)
            _method_missing(sym, args, block)
          end

          define_method :_method_missing do |sym, args, block|
            return original_method_missing.bind(self).call(sym, *args, &block) unless sym.to_s =~ /^should_/
            return Spec::Expectations::ShouldHelper.new(self).__send__(sym.to_s[7..-1], *args, &block)
          end
        end
      end
    end
  end
end