class RenderSpecController < ApplicationController
  def some_action
  end
  
  def text_action
    render :text=>"this the text for this action"
  end
end