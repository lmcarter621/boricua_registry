class FoundPeopleController < ApplicationController
  def show
    @people = FoundPerson.all
  end
end