class RenderSpecController < ApplicationController
  def some_action
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def text_action
    render :text=>"this the text for this action"
  end
end