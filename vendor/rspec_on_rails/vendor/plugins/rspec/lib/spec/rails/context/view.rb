module Spec
  module Rails
    class ViewEvalContext < Spec::Rails::FunctionalEvalContext

      attr_reader :response

      def setup
        super
        # these go here so that flash and session work as they should.
        @controller.send :initialize_template_class, @response
        @controller.send :assign_shortcuts, @request, @response
        @controller.send :reset_session

        assigns[:session] = @controller.session
        @controller.class.send :public, :flash # make flash accessible to the spec
        @controller.class.send :helper, :view_spec
      end

      def assigns
        @ivar_proxy ||= Spec::Rails::IvarProxy.new @controller 
      end

      def render(*options)
        options = Spec::Rails::OptsMerger.new(options).merge(:template)
        @action_name = action_name caller[0] if options.empty?
        assigns[:action_name] = @action_name

        @request.path_parameters = {
          :controller => @controller.controller_name,
          :action => @action_name,
        }

        defaults = { :layout => false }
        options = defaults.merge options

        @controller.instance_variable_set :@params, @request.parameters
        @controller.send :initialize_current_url

        # Rails 1.0
        @controller.send :assign_names rescue nil
        @controller.send :fire_flash rescue nil

        # Rails 1.1
        @controller.send :forget_variables_added_to_assigns rescue nil

        # Do the render
        @controller.render options

        # Rails 1.1
        @controller.send :process_cleanup rescue nil
      end
    end
    class ViewContext < Rails::Context
      def execution_context specification=nil
        instance = execution_context_class.new(specification)
        instance.instance_eval { @controller_class_name = "ActionController::Base" }
        instance
      end
      def before_context_eval
        inherit Spec::Rails::ViewEvalContext
      end
    end
  end
end



