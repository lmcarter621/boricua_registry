class FoundPerson < ActiveRecord::Base
  before_validation :clean_phone_number

  validates :first_name, :last_name, :birthday, :location, presence: true
  validates :phone_number, :numericality => true, :length => { :minimum => 7, :maximum => 10 }

  def clean_phone_number
    phone_number&.gsub!(/[^\D]/, '')
  end
end
