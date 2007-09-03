require 'spec/ui/watir/matchers'

module Spec
  module Ui
    module Watir
      class WatirExample < Spec::DSL::Example
        def before_eval # :nodoc:
          include Spec::Matchers::Watir
          begin
            # We'll try to hook up to the Rails stuff. This gives us access
            # to transactional fixtures etc.
            inherit Spec::Rails::DSL::EvalContext
            prepend_before {setup}
            append_after {teardown}
            configure
          rescue
          end
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:watir, self)
      end
    end
  end
end
