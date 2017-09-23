class AddPhoneNumberToFoundPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :found_people, :phone_number, :string unless column_exists? :found_people, :phone_number

    add_index :found_people, :phone_number
  end
end
