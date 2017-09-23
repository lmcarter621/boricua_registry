class AddReportedByToFoundPeople < ActiveRecord::Migration[5.1]
  def change
    rename_table :found_person, :found_people if table_exists?(:found_person)
    add_column :found_people, :reported_by_number, :string unless(column_exists?(:found_people, :reported_by_number))
  end
end
