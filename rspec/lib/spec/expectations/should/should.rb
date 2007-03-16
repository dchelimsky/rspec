module Spec
  module Expectations
    module Should # :nodoc:

      class Should < Base

        def initialize(target, expectation=nil)
          @target = target
          @be_seen = false
        end
        
        deprecated do
          #Gone for 0.9
          def not
            Not.new(@target)
          end
        end

        private
        def __delegate_method_missing_to_target(original_sym, actual_sym, *args)
          ::Spec::Matchers.generated_description = "should #{original_sym} #{args[0].inspect}"
          return if @target.send(actual_sym, *args)
          fail_with_message(default_message(original_sym, args[0]), args[0], @target)
        end
      end

    end
  end
end
