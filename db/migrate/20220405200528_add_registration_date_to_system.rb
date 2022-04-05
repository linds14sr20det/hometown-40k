class AddRegistrationDateToSystem < ActiveRecord::Migration[6.0]
  def change
    remove_column :cohorts, :descriptive_date
    remove_column :systems, :descriptive_date

    add_column :systems, :end_date, :timestamp
    add_column :systems, :registration_open, :timestamp
    add_column :systems, :registration_close, :timestamp
  end
end
