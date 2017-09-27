class FoundPerson < ActiveRecord::Base
  before_validation :clean_phone_number

  validates :first_name, :last_name, :birthday, :location, presence: true
  validates :phone_number, :numericality => true, :length => { :minimum => 7, :maximum => 10 }, allow_nil: true

  scope :filter_by, -> filters {
    result = self
    result = result.where('first_name ilike ?', "#{filters['first_name']}%") if filters['first_name'].present?
    result = result.where('last_name ilike ?', "#{filters['last_name']}%") if filters['last_name'].present?
    result = result.where('location ilike ?', "#{filters['location']}") if filters['location'].present?
    result = result.where('birthday = ?', filters['birthday'].to_datetime) if filters['birthday'].present?

    result
  }

  def clean_phone_number
    phone_number&.gsub!(/[^\D]/, '')
  end

  def age
    today = DateTime.now
    age = today.year - birthday.year

    return age if today.month > birthday.month
    return age-1 if birthday.month > today.month
    return age if today.month == birthday.month && birthday.day <= today.day
  end
end
