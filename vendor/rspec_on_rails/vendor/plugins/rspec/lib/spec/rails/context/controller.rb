module Spec
  module Rails
    class ControllerContext < Rails::Context
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
        #
        def render(options=nil, deprecated_status=nil, &block)
          #TODO - this "if @render_called" is a hack because render gets called twice.
          # Don't know why. That should be looked at.
          unless render_called?
            render_called
            if integrate_views?
              super
            else
              response.isolate_from_views!
            end
            # if options.nil? ActionController::Base is calling this
            # assuming that we're going to render the default template
            # associated with an action. Adding this to options allows
            # the specs to look consistent
            #
            # This may be a bit ticklish w/ future changes to rails, but
            # if problems are introduced, then there are specs that
            # invoke this that should fail. So at least we'll know what's what.
            render_matcher.set_rendered(ensure_default_options(options), &block)
          end
        end

        def should_render(expected)
          render_matcher.set_expectation(expected)
        end

        def should_have_rendered(expected)
          if integrate_views?
            if expected_template = expected[:template]
              expected_template.should == response.rendered_file
            end
          else
            render_matcher.verify_rendered(expected)
          end
        end

        def should_render_rjs(element, *opts)
          render_matcher.should_render_rjs(element, *opts)
        end

        def should_not_render_rjs(element, *opts)
          render_matcher.should_not_render_rjs(element, *opts)
        end
        
        def should_redirect_to(opts)
          @redirect_opts = opts
          @should_redirect_mock = Spec::Mocks::Mock.new("should redirect")
          @should_redirect_mock.should_receive(
            :redirect_to,
            :expected_from => caller(0)[1],
            :message => "controller expected call to redirect_to #{opts.inspect} but it was never received"
          ).with(opts)
        end
        
        def redirect_to(opts)
          if @redirect_opts
            @should_redirect_mock.__reset_mock if @redirect_opts
          end
          if integrate_views?
            super
          end
          if @redirect_opts
            if opts.is_a?(Hash) && (!@redirect_opts.is_a?(Hash))
              unless @redirect_opts.split('/').last == opts[:action]
                raise_should_redirect_error({ :action => @redirect_opts.split('/').last }, opts)
              end
            elsif @redirect_opts.is_a?(Hash) && (!opts.is_a?(Hash))
              unless @redirect_opts[:action] == opts.split('/').last
                raise_should_redirect_error(@redirect_opts, { :action => opts.split('/').last })
              end
            else
              unless @redirect_opts == opts
                raise_should_redirect_error(@redirect_opts, opts)
              end
            end
          end
        end
        
        def redirect?
          raise
          if integrate_views?
            super
          else
            @redirect == true
          end
        end
        
        def raise_should_redirect_error expected, actual
          message = "expected redirect to #{expected.inspect}"
          message << " but redirected to #{actual.inspect} instead"
          raise Spec::Expectations::ExpectationNotMetError.new(message)
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
          @render_matcher ||= Spec::Rails::RenderMatcher.new
        end

        def ensure_default_options(options)
          return {:template => default_template_name} if options.nil?
          return options
        end
      end

      module ContextEvalInstanceMethods
        attr_reader :response, :request, :controller
        #This is a hook provided by Test::Rails::TestCase
        def setup_extra
          (class << @controller; self; end).class_eval do
            include ControllerInstanceMethods
          end
          @controller.integrate_views! if @integrate_views
        end
      end

      module ContextEvalClassMethods
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
        inherit Test::Rails::ControllerTestCase
        @context_eval_module.extend ControllerContext::ContextEvalClassMethods
        @context_eval_module.include ControllerContext::ContextEvalInstanceMethods
      end
    end
  end
end