module Spec
  module Rails
    module DSL
      # Controller Examples live in $RAILS_ROOT/spec/controllers/.
      #
      # Controller Examples use Spec::Rails::DSL::ControllerBehaviour, which supports running specs for
      # Controllers in two modes, which represent the tension between the more granular
      # testing common in TDD and the more high level testing built into
      # rails. BDD sits somewhere in between: we want to a balance between
      # specs that are close enough to the code to enable quick fault
      # isolation and far enough away from the code to enable refactoring
      # with minimal changes to the existing specs.
      #
      # == Isolation mode (default)
      #
      # No dependencies on views because none are ever rendered. The
      # benefit of this mode is that can spec the controller completely
      # independent of the view, allowing that responsibility to be
      # handled later, or by somebody else. Combined w/ separate view
      # specs, this also provides better fault isolation.
      #
      # == Integration mode
      #
      # To run in this mode, include the +integrate_views+ declaration
      # in your controller context:
      # 
      #   describe ThingController do
      #     integrate_views
      #     ...
      # 
      # In this mode, controller specs are run in the same way that
      # rails functional tests run - one set of tests for both the
      # controllers and the views. The benefit of this approach is that
      # you get wider coverage from each spec. Experienced rails
      # developers may find this an easier approach to begin with, however
      # we encourage you to explore using the isolation mode and revel
      # in its benefits.
      #
      # == Expecting Errors
      #
      # Rspec on Rails will raise errors that occur in controller actions.
      # In contrast, Rails will swallow errors that are raised in controller
      # actions and return an error code in the header. If you wish to override
      # Rspec and have Rail's default behaviour,tell the controller to use
      # rails error handling ...
      #
      #   before(:each) do
      #     controller.use_rails_error_handling!
      #   end
      #
      # When using Rail's error handling, you can expect error codes in headers ...
      #
      #   it "should return an error in the header" do
      #     response.should be_error
      #   end
      #
      #   it "should return a 501" do
      #     response.response_code.should == 501
      #   end
      #
      #   it "should return a 501" do
      #     response.code.should == "501"
      #   end
      class ControllerBehaviour < FunctionalBehaviour
        def before_eval # :nodoc:
          super
          prepend_before {controller_setup}
          append_after {@test_case.teardown}
          configure
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:controller, self)

        # Use this to instruct RSpec to render views in your controller examples (Integration Mode).
        #
        #   describe ThingController do
        #     integrate_views
        #     ...
        #
        # See Spec::Rails::DSL::ControllerBehaviour for more information about
        # Integration and Isolation modes.
        def integrate_views
          @integrate_views = true
        end
        def integrate_views? # :nodoc:
          @integrate_views
        end

        def example_space_superclass # :nodoc:
          ControllerExample
        end
      end
    end
  end
end
