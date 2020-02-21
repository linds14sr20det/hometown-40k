class AddPlayerAndSystemIndexToRoundAggregates < ActiveRecord::Migration[6.0]
  def change
    add_index :round_aggregates, [:system_id, :player_id], unique: true
  end
end
