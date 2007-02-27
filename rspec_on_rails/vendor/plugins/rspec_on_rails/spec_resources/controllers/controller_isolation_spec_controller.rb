class ControllerIsolationSpecController < ActionController::Base
  
  def some_action
    render :template => "template/that/does/not/actually/exist"
  end
  
  def action_with_template
    session[:session_key] = "session value"
    flash[:flash_key] = "flash value"
    render :template => "../../vendor/plugins/rspec_on_rails/spec_resources/views/controller_isolation_spec/action_with_template"
  end
  
  def action_with_partial
    render :partial => "../../vendor/plugins/rspec_on_rails/spec_resources/views/controller_isolation_spec/a_partial"
  end
  
  def action_with_errors_in_template
    render :template => "../../vendor/plugins/rspec_on_rails/spec_resources/views/controller_isolation_spec/action_with_errors_in_template"
  end
end