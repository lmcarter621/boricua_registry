class FoundPeopleController < ApplicationController
  def show
    @old_search_params = {
      first_name: params['first_name'],
      last_name: params['last_name'],
      location: params['location'],
      birthday: params['birthday'],
    }

    return unless params["commit"].present? && params["commit"] == "Search"
    @people = FoundPerson.filter_by(params.to_unsafe_h)
  end
end
