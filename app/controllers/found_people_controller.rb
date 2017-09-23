class FoundPeopleController < ApplicationController
  def show
    @old_search_params = {
      first_name: params['first_name'],
      last_name: params['last_name'],
      location: params['location'],
      birthday: params['birthday'],
      status: params['status'],
    }

    @people = FoundPerson.all
    @people = @people.where('first_name like ?', "#{params['first_name']}%") if params['first_name'].present?
    @people = @people.where('last_name like ?', "#{params['last_name']}%") if params['last_name'].present?
    @people = @people.where('location like ?', "#{params['location']}") if params['location'].present?
    @people = @people.where('birthday = ?', params['birthday'].to_datetime) if params['birthday'].present?
    @people = @people.where('status like ?', "#{params['status']}") if params['status'].present?
  end
end
