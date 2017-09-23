class AddFoundPersonTable < ActiveRecord::Migration[5.1]
  def change
    create_table :found_person do |t|
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.string :phone_number
      t.string :location
      t.string :status
      t.timestamps
      t.index [:last_name, :first_name]
    end
  end
end
