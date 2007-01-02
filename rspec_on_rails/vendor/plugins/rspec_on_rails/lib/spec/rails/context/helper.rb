module Spec
  module Rails
    class HelperEvalContextController < ApplicationController

      attr_accessor :request, :url

      ##
      # Re-raise errors

      def rescue_action(e)
        raise e
      end

    end

    class HelperEvalContext < Spec::Rails::FunctionalEvalContext

      include ActionView::Helpers::ActiveRecordHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::PrototypeHelper rescue nil # Rails 1.0 only

      def setup
        @controller_class_name = 'Spec::Rails::HelperEvalContextController'
        super
        @controller.request = @request
        @controller.url = ActionController::UrlRewriter.new @request, {} # url_for

        ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
      end
      
    end

    class HelperContext < Spec::Rails::Context
      module ContextEvalClassMethods
        def helper_name(name=nil)
          send :include, "#{name}_helper".camelize.constantize
        end
      end
      def before_context_eval
        inherit_context_eval_module_from Spec::Rails::HelperEvalContext
        @context_eval_module.extend HelperContext::ContextEvalClassMethods
        @context_eval_module.init_global_fixtures
      end
    end
  end
end

