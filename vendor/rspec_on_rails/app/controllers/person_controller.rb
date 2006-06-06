class PersonController < ApplicationController

  def index
    @people = Person.find :all
  end

  def create
    if request.post?
      Person.create(params[:person])
      redirect_to :action => 'index'
    else
      @person = Person.new
    end
  end
end
