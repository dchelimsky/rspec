class PersonController < ApplicationController

  def index
    @people = Person.find :all
  end

  def create
  end
end
