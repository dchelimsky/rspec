class RedirectSpecController < ApplicationController

  def action_with_no_redirect
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def action_with_redirect_to_somewhere
    redirect_to :action => 'somewhere'
  end
  
  def action_with_redirect_to_somewhere_and_return
    redirect_to :action => 'somewhere' and return
  end
  
  def somewhere
    render :text => "this is just here to keep this from causing a MissingTemplate error"
  end
  
  def action_with_redirect_to_rspec_site
    redirect_to "http://rspec.rubyforge.org"
  end
  
  def action_with_redirect_back
    redirect_to :back
  end    

end

