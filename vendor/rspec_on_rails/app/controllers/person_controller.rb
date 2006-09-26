class PersonController < ApplicationController

  def index
    @people = Person.find :all
    render :template => 'person/list'
  end

  def create
    if request.post?
      Person.create(params[:person])
      redirect_to :action => 'index'
    else
      @person = Person.new
    end
  end
  
  def a_replace_html_call
    render :update do |page|
      page.replace_html 'mydiv', 'replacement text'
    end
  end
  
  def an_insert_html_call
    render :update do |page|
      page.insert_html 'mydiv', 'replacement text'
    end
  end
  
  def a_replace_call
    render :update do |page|
      page.replace 'mydiv', 'replacement text'
    end
  end
  
  def hide_div
    render :update do |page|
      page.hide 'mydiv'
    end
  end
end
