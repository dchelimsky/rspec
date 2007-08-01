module Spec
  module Rails
    module DSL
      module HelperBehaviourHelpers
        class << self
          def included(mod)
            mod.send :include, ExampleMethods
            mod.send :extend, BehaviourMethods
          end
        end
        
        module BehaviourMethods
          # The helper name....
          def helper_name(name=nil)
            send :include, "#{name}_helper".camelize.constantize
          end
        end
        
        module ExampleMethods
          include ActionView::Helpers::ActiveRecordHelper
          include ActionView::Helpers::AssetTagHelper
          include ActionView::Helpers::BenchmarkHelper
          include ActionView::Helpers::CacheHelper
          include ActionView::Helpers::CaptureHelper
          include ActionView::Helpers::DateHelper
          include ActionView::Helpers::DebugHelper
          include ActionView::Helpers::FormHelper
          include ActionView::Helpers::FormOptionsHelper
          include ActionView::Helpers::FormTagHelper
          include ActionView::Helpers::JavaScriptHelper
          include ActionView::Helpers::JavaScriptMacrosHelper
          include ActionView::Helpers::NumberHelper
          include ActionView::Helpers::PaginationHelper rescue nil #removed after 1.2.3
          include ActionView::Helpers::PrototypeHelper
          include ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods
          include ActionView::Helpers::ScriptaculousHelper
          include ActionView::Helpers::TagHelper
          include ActionView::Helpers::TextHelper
          include ActionView::Helpers::UrlHelper

          def eval_erb(text)
            ERB.new(text).result(binding)
          end

        end
      end

      class HelperEvalContextController < ApplicationController #:nodoc:
        attr_accessor :request, :url

        # Re-raise errors
        def rescue_action(e); raise e; end
      end

      class HelperEvalContext < Spec::Rails::DSL::FunctionalEvalContext
        include Spec::Rails::DSL::HelperBehaviourHelpers

        def setup #:nodoc:
          @controller_class_name = 'Spec::Rails::DSL::HelperEvalContextController'
          super
          @controller.request = @request
          @controller.url = ActionController::UrlRewriter.new @request, {} # url_for
          
          @flash = ActionController::Flash::FlashHash.new
          session['flash'] = @flash

          ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
        end
        
        def flash
          @flash
        end
      
      end

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
      class HelperBehaviour < Spec::DSL::Behaviour
        def before_eval #:nodoc:
          inherit Spec::Rails::DSL::HelperEvalContext
          prepend_before {setup}
          append_after {teardown}
          configure
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:helper, self)
      end
    end
  end
end
