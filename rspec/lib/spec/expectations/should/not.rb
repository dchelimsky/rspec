module Spec
  module Expectations
    module Should
      
      class Not < Base #:nodoc:
        def initialize(target)
          @target = target
          @be_seen = false
        end

        deprecated do
          def __delegate_method_missing_to_target original_sym, actual_sym, *args
            ::Spec::Matchers.generated_description = "should not #{original_sym} #{args[0].inspect}"
            return unless @target.__send__(actual_sym, *args)
            fail_with_message(default_message("not #{original_sym}", args[0]))
          end
        end
      end

    end
  end
end
