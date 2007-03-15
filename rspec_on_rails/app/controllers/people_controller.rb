class PeopleController < ApplicationController

  def index
    @people = Person.find(:all)
    render :template => 'people/list'
  end

  def create
    if request.post?
      @person = Person.create(params[:person])
      unless @person.new_record?
        redirect_to :action => 'index'
      else
        render :template => 'people/create'
      end
    else
      @person = Person.new
      render :template => 'people/create'
    end
  end
  
  def show
    @person = Person.find(params[:id])
    show_404 and return unless @person
    render :template => 'people/show'
  end

  protected

  def show_404
    render( :file => "#{RAILS_ROOT}/public/404.html",
            :status => "404 Not Found" )
  end
  
end