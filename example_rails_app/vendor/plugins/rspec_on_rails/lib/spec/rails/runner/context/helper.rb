module Spec
  module Rails
    module Runner
      class HelperEvalContextController < ApplicationController #:nodoc:

        attr_accessor :request, :url

        ##
        # Re-raise errors

        def rescue_action(e)
          raise e
        end

      end

      class HelperEvalContext < Spec::Rails::Runner::FunctionalEvalContext

        include ActionView::Helpers::ActiveRecordHelper
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::FormTagHelper
        include ActionView::Helpers::FormOptionsHelper
        include ActionView::Helpers::FormHelper
        include ActionView::Helpers::UrlHelper
        include ActionView::Helpers::AssetTagHelper
        include ActionView::Helpers::PrototypeHelper rescue nil # Rails 1.0 only
        
        class << self
          # The helper name....
          def helper_name(name=nil)
            send :include, "#{name}_helper".camelize.constantize
          end
        end

        def setup #:nodoc:
          @controller_class_name = 'Spec::Rails::Runner::HelperEvalContextController'
          super
          @controller.request = @request
          @controller.url = ActionController::UrlRewriter.new @request, {} # url_for

          ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
        end
      
      end

      # Helper Specs live in $RAILS_ROOT/spec/helpers/.
      #
      # Helper Specs use Spec::Rails::Runner::HelperContext, which allows you to
      # include your Helper directly in the context and write specs directly
      # against its methods.
      #
      # HelperContext also includes the standard lot of ActionView::Helpers in case your
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
      #   context "ThingHelper behaviour" do
      #     include ThingHelper
      #     specify "should tell you the number of things" do
      #       Thing.should_receive(:count).and_return(37)
      #       number_of_things.should == 37
      #     end
      #   end
      class HelperContext < Spec::Rails::Runner::Context
        def before_eval #:nodoc:
          inherit Spec::Rails::Runner::HelperEvalContext
          init_global_fixtures
        end
      end
    end
  end
end
