module Spec
  module Rails
    module DSL
      class ControllerExampleSpace < FunctionalExampleSpace
        module ControllerInstanceMethods #:nodoc:
          include Spec::Rails::DSL::RenderObserver

          # === render(options = nil, deprecated_status = nil, &block)
          #
          # This gets added to the controller's singleton meta class,
          # allowing Controller Examples to run in two modes, freely switching
          # from context to context.
          def render(options=nil, deprecated_status=nil, &block)
            unless block_given?
              unless integrate_views?
                @template.metaclass.class_eval do
                  define_method :file_exists? do
                    true
                  end
                  define_method :render_file do |*args|
                    @first_render ||= args[0]
                  end
                end
              end
            end

            if expect_render_mock_proxy.send(:__mock_proxy).send(:find_matching_expectation, :render, options)
              expect_render_mock_proxy.render(options)
              @performed_render = true
            else
              unless expect_render_mock_proxy.send(:__mock_proxy).send(:find_matching_method_stub, :render, options)
                super(options, deprecated_status, &block)
              end
            end
          end

          if self.respond_to?(:should_receive) && self.respond_to?(:stub!)
            self.send :alias_method, :orig_should_receive, :should_receive
            self.send :alias_method, :orig_stub!, :stub!
            def raise_with_disable_message(old_method, new_method)
              raise %Q|
        controller.#{old_method}(:render) has been disabled because it
        can often produce unexpected results. Instead, you should
        use the following (before the action):

        controller.#{new_method}(*args)

        See the rdoc for #{new_method} for more information.
              |
            end
            def should_receive(*args)
              if args[0] == :render
                raise_with_disable_message("should_receive", "expect_render")
              else
                orig_should_receive(*args)
              end
            end
            def stub!(*args)
              if args[0] == :render
                raise_with_disable_message("stub!", "stub_render")
              else
                orig_stub!(*args)
              end
            end
          end

          def response(&block)
            # NOTE - we're setting @update for the assert_select_spec - kinda weird, huh?
            @update = block
            @_response || @response
          end

          def integrate_views!
            @integrate_views = true
          end

          private

          def integrate_views?
            @integrate_views
          end
        end

        attr_reader :response, :request, :controller

        def initialize(behaviour, example)
          super
          if rspec_behaviour.controller_class_name
            @controller_class_name = rspec_behaviour.controller_class_name.to_s
          else
            @controller_class_name = rspec_behaviour.described_type.to_s
          end
          @integrate_views = rspec_behaviour.integrate_views?
        end

        def controller_setup #:nodoc:
          functional_setup

          # Some Rails apps explicitly disable ActionMailer in environment.rb
          if defined?(ActionMailer)
            @deliveries = []
            ActionMailer::Base.deliveries = @deliveries
          end

          unless @controller.class.ancestors.include?(ActionController::Base)
            Spec::Expectations.fail_with <<-EOE
            You have to declare the controller name in controller specs. For example:
            describe "The ExampleController" do
            controller_name "example" #invokes the ExampleController
            end
            EOE
          end
          @controller.metaclass.class_eval do
            def controller_path #:nodoc:
              self.class.name.underscore.gsub('_controller', '')
            end
            include ControllerInstanceMethods
          end
          @controller.integrate_views! if @integrate_views
          @controller.session = session
        end

        # Uses ActionController::Routing::Routes to generate
        # the correct route for a given set of options.
        # == Examples
        #   route_for(:controller => 'registrations', :action => 'edit', :id => 1)
        #     => '/registrations/1;edit'
        def route_for(options)
          ensure_that_routes_are_loaded
          ActionController::Routing::Routes.generate(options)
        end

        protected
        def _controller_ivar_proxy
          @controller_ivar_proxy ||= AssignsHashProxy.new @controller
        end

        private
        def ensure_that_routes_are_loaded
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
        end
      end
    end
  end
end
