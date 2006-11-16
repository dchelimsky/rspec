class Spec::Rails::ControllerTestCase < Spec::Rails::FunctionalTestCase

  def setup
    super

    @controller_class.send(:define_method, :rescue_action) { |e| raise e }

    @deliveries = []
    ActionMailer::Base.deliveries = @deliveries
  end

  def routing(options)
    # Load routes.rb if it hasn't been loaded
    ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
    ActionController::Routing::Routes.generate(options)[0]
  end

  def assigns
    @ivar_proxy ||= Spec::Rails::IvarProxy.new(controller)
  end
end


