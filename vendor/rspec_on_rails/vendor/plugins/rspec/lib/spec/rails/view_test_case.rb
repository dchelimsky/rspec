class Spec::Rails::ViewTestCase < Spec::Rails::FunctionalTestCase

  def setup
    super
    # these go here so that flash and session work as they should.
    @controller.send :initialize_template_class, @response
    @controller.send :assign_shortcuts, @request, @response
    @controller.send :reset_session
  
    assigns[:session] = @controller.session
    @controller.class.send :public, :flash # make flash accessible to the test
  end

  def assigns
    @ivar_proxy ||= Spec::Rails::IvarProxy.new @controller 
  end

  def render(options = {}, deprecated_status = nil)
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
    @controller.render options, deprecated_status

    # Rails 1.1
    @controller.send :process_cleanup rescue nil
  end
end

