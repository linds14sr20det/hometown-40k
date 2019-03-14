class AddInfoToCohort < ActiveRecord::Migration[5.0]
  def change
    add_reference :infos, :cohort, index: true
    add_foreign_key :infos, :cohorts
  end
end
