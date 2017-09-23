class AddPhoneNumberToFoundPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :found_people, :phone_number, :string

    add_index :found_people, :phone_number
  end
end
