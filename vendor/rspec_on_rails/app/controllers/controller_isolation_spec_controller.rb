class ControllerIsolationSpecController < ActionController::Base
  def some_action
    render :template => "/file/that/does/not/actually/exist"
  end
  
  def action_with_template
    flash[:flash_key] = "flash value"
    session[:session_key] = "session value"
  end
  
  def action_with_specified_template
    render :template => "controller_isolation_spec/specified_template"
  end
  
  def action_with_errors_in_template
  end
  
  def action_with_partial
    render :partial => "controller_isolation_spec/a_partial"
  end
end
