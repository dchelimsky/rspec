class RedirectSpecController < ApplicationController

  def action_with_no_redirect
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def action_with_redirect_to_somewhere
    redirect_to :action => 'somewhere'
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def somewhere
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def action_with_redirect_to_rspec_site
    redirect_to "http://rspec.rubyforge.org"
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def action_with_redirect_back
    redirect_to :back
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end

end