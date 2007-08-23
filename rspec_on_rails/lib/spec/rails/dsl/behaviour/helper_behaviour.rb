module Spec
  module Rails
    module DSL
      # Helper Specs live in $RAILS_ROOT/spec/helpers/.
      #
      # Helper Specs use Spec::Rails::DSL::HelperBehaviour, which allows you to
      # include your Helper directly in the context and write specs directly
      # against its methods.
      #
      # HelperBehaviour also includes the standard lot of ActionView::Helpers in case your
      # helpers rely on any of those.
      #
      # == Example
      #
      #   class ThingHelper
      #     def number_of_things
      #       Thing.count
      #     end
      #   end
      #
      #   describe "ThingHelper behaviour" do
      #     include ThingHelper
      #     it "should tell you the number of things" do
      #       Thing.should_receive(:count).and_return(37)
      #       number_of_things.should == 37
      #     end
      #   end
      class HelperBehaviour < FunctionalBehaviour
        def before_eval #:nodoc:
          super
          prepend_before {helper_setup}
          append_after {@test_case.teardown}
          configure
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:helper, self)

        # The helper name....
        def helper_name(name=nil)
          send :include, "#{name}_helper".camelize.constantize
        end

        def example_space_superclass #:nodoc:
          HelperExample
        end
      end
    end
  end
end
