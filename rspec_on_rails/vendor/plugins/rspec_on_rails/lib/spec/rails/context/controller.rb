module Spec
  module Rails

    module ControllerInstanceMethods
      # === render(options = nil, deprecated_status = nil, &block)
      #
      # This gets added to the controller's singleton meta class,
      # allowing Controller Specs to run in two modes, freely switching
      # from spec to spec.
      #
      # The two modes represent the tension between the more granular
      # testing common in TDD and the more high level testing built into
      # rails. BDD sits somewhere in between: we want to a balance between
      # specs that are close enough to the code to enable quick fault
      # isolation and far enough away from the code to enable refactoring
      # with minimal changes to the existing specs.
      #
      # Isolation mode (default)
      #
      #   No dependencies on views because none are ever rendered. The
      #   benefit of this mode is that can spec the controller completely
      #   independent of the view, allowing that responsibility to be
      #   handled later, or by somebody else. Combined w/ separate view
      #   specs, this also provides better fault isolation.
      #
      # Integration mode
      #
      #   To run in this mode, include the following line in your spec:
      #
      #     integrate_views
      #
      #   In this mode, controller specs are run in the same way that
      #   rails functional tests run - one set of tests for both the
      #   controllers and the views. The benefit of this approach is that
      #   you get wider coverage from each spec. Experienced rails
      #   developers may find this an easier approach to begin with, however
      #   we encourage you to explore using the isolation mode and revel
      #   in its benefits.
      def render(options=nil, deprecated_status=nil, &block)
        unless block_given?
          unless integrate_views?
            @template = Spec::Mocks::Mock.new("template") 
            @template.stub!(:evaluate_assigns)
            @template.stub!(:render)
            @template.stub!(:file_exists?).and_return(true)
            @template.stub!(:full_template_path)
            @template.stub!(:render_file).and_return(true)
            @template.stub!(:render_partial)
          end
        end
        render_matcher.set_actual(ensure_default_options(options), response, &block)
        response.controller_path = controller_path
        response.render_matcher = render_matcher
        super unless performed?
      end
      
      def response
        @_response || @response
      end
      
      def should_render(expected)
        if expected.is_a?(Symbol) || expected.is_a?(String)
          expected = {:template => "#{controller_path}/#{expected}"}
        end
        render_matcher.set_expected(expected)
      end
      
      #backwards compatibility to RSpec 0.7.0-0.7.2
      alias_method :should_have_rendered, :should_render

      def should_render_rjs(element, *opts)
        render_matcher.should_render_rjs(element, *opts)
      end

      def should_not_render_rjs(element, *opts)
        render_matcher.should_not_render_rjs(element, *opts)
      end
      
      def should_redirect_to(opts)
        redirect_matcher.set_expected(opts)
      end
      
      def redirect_to(opts)
        super
        redirect_matcher.match(request, opts) if redirect_matcher.interested_in?(opts)
      end

      def integrate_views!
        @integrate_views = true
      end

    private

      def integrate_views?
        @integrate_views
      end
      
      def render_called
        @render_called = true
      end

      def render_called?
        @render_called
      end

      def render_matcher
        @render_matcher ||= Spec::Rails::RenderMatcher.new(controller_path, integrate_views?)
      end

      def redirect_matcher
        @redirect_matcher ||= Spec::Rails::RedirectMatcher.new
      end
      
      def ensure_default_options(options)
        options ||= {:template => default_template_name}
        return options
      end
    end
    
    class ControllerEvalContext < Spec::Rails::FunctionalEvalContext
      attr_reader :response, :request, :controller
      
      def setup_extra
        (class << @controller; self; end).class_eval do
          # Rails 1.1.6 doesn't have controller_path, but >= 1.2.0 does
          unless instance_methods.include?("controller_path")
            def controller_path
              self.class.name.underscore.gsub('_controller','')
            end
          end
          include ControllerInstanceMethods
        end
        @controller.integrate_views! if @integrate_views
        @controller.session = session
      end

      class << self
        attr_accessor :controller_class_name
        def controller_name(name=nil)
          @controller_class_name = "#{name}_controller".camelize
        end
        def integrate_views
          @integrate_views = true
        end
        def integrate_views?
          @integrate_views
        end
      end

      def setup
        super

        @controller_class.send(:define_method, :rescue_action) { |e| raise e }

        @deliveries = []
        ActionMailer::Base.deliveries = @deliveries
      end

      def route_for(options)
        ensure_that_routes_are_loaded
        routes = ActionController::Routing::Routes.generate(options)
        # Rails 1.1.6
        return routes[0] if routes.is_a?(Array)
        # Rails 1.2
        return routes if routes.is_a?(String)
      end
      
      #backwards compatibility to RSpec 0.7.0-0.7.3
      alias_method :routing, :route_for
      
      private
        def ensure_that_routes_are_loaded
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
        end
    end

    class ControllerContext < Spec::Rails::Context

      def execution_context specification=nil
        instance = execution_context_class.new(specification)
        controller_class_name = @context_eval_module.controller_class_name
        integrate_views = @context_eval_module.integrate_views? ? true : false
        instance.instance_eval {
          @controller_class_name = controller_class_name.to_s
          @integrate_views = integrate_views
        }
        instance
      end

      def before_context_eval
        inherit_context_eval_module_from Spec::Rails::ControllerEvalContext
        @context_eval_module.init_global_fixtures
      end

    end
  end
end