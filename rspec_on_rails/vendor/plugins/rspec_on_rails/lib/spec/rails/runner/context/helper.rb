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

      class HelperContext < Spec::Rails::Runner::Context
        def before_context_eval #:nodoc:
          inherit_context_eval_module_from Spec::Rails::Runner::HelperEvalContext
          @context_eval_module.init_global_fixtures
        end
      end
    end
  end
end
