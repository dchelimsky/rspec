module Spec
  module Rails
    module DSL
      module ControllerBehaviourHelpers
        class << self
          def included(mod)
            mod.send :include, ExampleMethods
            mod.send :extend,  BehaviourMethods
          end
        end
        
        module BehaviourMethods
          attr_accessor :controller_class_name # :nodoc:
          
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
        end
        
        module ExampleMethods
          # Uses ActionController::Routing::Routes to generate
          # the correct route for a given set of options.
          # == Examples
          #   route_for(:controller => 'registrations', :action => 'edit', :id => 1)
          #     => '/registrations/1;edit'
          def route_for(options)
            ensure_that_routes_are_loaded
            ActionController::Routing::Routes.generate(options)
          end
        end
      end

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
                define_method :file_exists? do true end
                define_method :render_file do |*args|
                  @first_render ||= args[0]
                end
              end
            end
          end
          
          if (Hash === options)
            expect_render_mock_proxy.render(options)
          end
          if expect_render_mock_proxy.send(:__mock_proxy).send(:find_matching_expectation, :render, options)
            @performed_render = true
          else
            super(options, deprecated_status, &block)
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
    
      # The methods provided by Spec::Rails::DSL::ControllerEvalContext
      # are available to you in Controller Examples.
      #
      # The Public Class Methods are to be used within the +context+ block:
      #
      #   describe ThingController do
      #     # public class methods go here
      #
      # The Public Instance Methods are to be used within the +specify+ block:
      #
      #   describe ThingController do
      #     it "should do stuff" do
      #       # public instance methods go here
      #
      # See Spec::Rails::DSL::ControllerBehaviour for more general information
      # on Controller Examples
      class ControllerEvalContext < Spec::Rails::DSL::FunctionalEvalContext
        include Spec::Rails::DSL::ControllerBehaviourHelpers
        attr_reader :response, :request, :controller
      
        def setup #:nodoc:
          super
          
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
              self.class.name.underscore.gsub('_controller','')
            end
            include ControllerInstanceMethods
          end
          @controller.integrate_views! if @integrate_views
          @controller.session = session
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
      #
      # See Spec::Rails::DSL::ControllerEvalContext for information
      # about methods you can use in your Controller Examples
      class ControllerBehaviour < Spec::DSL::Behaviour
        def execution_context(example=nil) # :nodoc:
          instance = execution_context_class.new(example)
          if controller_class_name.nil? && !described_type.nil?
            controller_klass_name = described_type.to_s
          else
            controller_klass_name = controller_class_name.to_s
          end
          integrate_views = integrate_views?
          instance.instance_eval {
            @controller_class_name = controller_klass_name
            @integrate_views = integrate_views
          }
          instance
        end

        def before_eval # :nodoc:
          inherit Spec::Rails::DSL::ControllerEvalContext
          prepend_before {setup}
          append_after {teardown}
          configure
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:controller, self)
      end
    end
  end
end
