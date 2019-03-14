class AddCohortToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :cohorts, :user, index: true
    add_foreign_key :cohorts, :users
  end
end
