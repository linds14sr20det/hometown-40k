class RenameFinalizedAndAddComplete < ActiveRecord::Migration[5.2]
  def change
    rename_column :rounds, :finalized, :complete
    add_column :registrants, :checked_in, :boolean
    remove_column :round_individuals, :round
  end
end
