module Spec
  module Rails
    module DSL
      # View Examples live in $RAILS_ROOT/spec/views/.
      #
      # View Specs use Spec::Rails::DSL::ViewBehaviour,
      # which provides access to views without invoking any of your controllers.
      # See Spec::Rails::Expectations::Matchers for information about specific
      # expectations that you can set on views.
      #
      # == Example
      #
      #   describe "login/login" do
      #     before do
      #       render 'login/login'
      #     end
      # 
      #     it "should display login form" do
      #       response.should have_tag("form[action=/login]") do
      #         with_tag("input[type=text][name=email]")
      #         with_tag("input[type=password][name=password]")
      #         with_tag("input[type=submit][value=Login]")
      #       end
      #     end
      #   end
      class ViewBehaviour < FunctionalBehaviour
        def before_eval # :nodoc:
          super
          prepend_before {view_setup}
          append_after {@test_case.teardown}
          configure
        end

        def example_class #:nodoc:
          ViewExample
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:view, self)
      end
    end
  end
end
