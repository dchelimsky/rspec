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
        def render(options = nil, deprecated_status = nil, &block)
          @render_called_first = true unless @should_render_called
          if integrate_views?
            super
          else
            # if options.nil? ActionController::Base is calling this
            # assuming that we're going to render the default template
            # associated with an action. Adding this to options allows
            # the specs to look consistent
            #
            # This may be a bit ticklish w/ future changes to rails, but
            # if problems are introduced, then there are specs that
            # invoke this that should fail. So at least we'll know what's what.
            
            options = {:template => default_template_name} if options.nil?
            set_view_isolation_options options, &block
          end
        end
        
        def should_render(expected)
          @should_render_called = true unless @render_called_first
          if integrate_views?
            if expected_template = expected[:template]
              expected_template.should == response.rendered_file
            end
          else
            @view_isolator.match(expected)
          end
        end
        
        def should_render_rjs(element, *opts)
          @view_isolator.should_have_rjs(element, *opts)
        end

        def should_not_render_rjs(element, *opts)
          @view_isolator.should_not_have_rjs(element, *opts)
        end
        
        def integrate_views!
          @integrate_views = true
        end
        
        private
        def integrate_views?
          @integrate_views
        end

        def set_view_isolation_options(options, &block)
          #TODO - this "if @view_isolator.nil?" is a hack because this method gets called twice
          # and the 2nd time it gets called w/ nil. Don't know why. That should be looked at.
          if @view_isolator.nil?
            @view_isolator = Spec::Rails::ViewIsolator.new(options, block)
            response.isolate_from_views!
          end
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
          @controller_class_name = "#{controller_class_name}"
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

