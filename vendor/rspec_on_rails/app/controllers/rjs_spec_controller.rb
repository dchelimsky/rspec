class RjsSpecController < ApplicationController
  def replace_html
  end
  
  def insert_html
  end
  
  def replace
  end
  
  def hide_div
  end
  
  def hide_page_element
  end

  def render_replace_html
    render :update do |page|
      page.replace_html 'mydiv', 'replacement text'
      page.replace_html 'myotherdiv', 'other replacement text'
    end
  end
  
  def render_insert_html
    render :update do |page|
      page.insert_html 'mydiv', 'replacement text'
    end
  end
  
  def render_replace
    render :update do |page|
      page.replace 'mydiv', 'replacement text'
    end
  end
  
  def render_hide_div
    render :update do |page|
      page.hide 'mydiv'
    end
  end
  
  def render_hide_page_element
    render :update do |page|
      page['mydiv'].hide
    end
  end
end
