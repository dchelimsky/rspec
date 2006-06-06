class PersonController < ApplicationController

  def index
    @people = Person.find :all
  end

  def create
    @person = Person.new
  end
end
