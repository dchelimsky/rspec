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
  
  def show
    @person = Person.find(params[:id])
  end
  
end