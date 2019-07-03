class AddFinalizedToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :finalized, :boolean
  end
end
