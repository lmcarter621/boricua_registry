class FoundPeopleController < ApplicationController
  def show
    @old_search_params = {
      first_name: params['first_name'],
      last_name: params['last_name'],
      location: params['location'],
      birthday: params['birthday'],
    }

    @people = person_object
    @people = @people.where('first_name ilike ?', "#{params['first_name']}%") if params['first_name'].present?
    @people = @people.where('last_name ilike ?', "#{params['last_name']}%") if params['last_name'].present?
    @people = @people.where('location ilike ?', "#{params['location']}") if params['location'].present?
    @people = @people.where('birthday = ?', params['birthday'].to_datetime) if params['birthday'].present?
  end

  private

  def person_object
    return unless params["commit"].present? && params["commit"] == "Search"

    FoundPerson
  end
end
